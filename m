Return-Path: <linux-kernel-owner+w=401wt.eu-S1756159AbYJMIC7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756159AbYJMIC7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2008 04:02:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754724AbYJMICp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Oct 2008 04:02:45 -0400
Received: from fg-out-1718.google.com ([72.14.220.157]:48833 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754422AbYJMICo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2008 04:02:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=MaLwVVdyMmFWt6rb3gn5R6xyw/ov+H1KUc/bN0WgHYsm38b0++jSI7UYvozxDdoGP8
         X8XMS1dQPitQVsLjbg8wYtp5AbAuWa0bqaWqM8gcpY6BNxQIpZ/1wl3JCC0oa/PsVrFt
         v4FlaETbA68cje5ya9FE21xNFpiVfELgPXGv8=
Message-ID: <c62985530810130102y37dc8f44n631cecac81ccc5f1@mail.gmail.com>
Date: Mon, 13 Oct 2008 10:02:42 +0200
From: "=?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?=" <fweisbec@gmail.com>
To: "=?ISO-8859-1?Q?T=F6r=F6k_Edwin?=" <edwintorok@gmail.com>
Subject: Re: [PATCH 1/4] Add support for userspace stacktraces in tracing/iter_ctrl
Cc: mingo@elte.hu, srostedt@redhat.com, a.p.zijlstra@chello.nl,
       sandmann@daimi.au.dk, linux-kernel@vger.kernel.org
In-Reply-To: <48F20142.3070002@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
References: <1223817124-27239-1-git-send-email-edwintorok@gmail.com>
	 <1223817124-27239-3-git-send-email-edwintorok@gmail.com>
	 <c62985530810120631g3e464503i8958d160e6b1aa3e@mail.gmail.com>
	 <48F20142.3070002@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/10/12 Török Edwin <edwintorok@gmail.com>:
> Hello,
>
> This function is called from ftrace, as such I could be holding a
> spinlock. It can also be called from
> __rwsem_do_wake, which takes a spinlock.
> This code is from sysprof's copy_stack_frame. Maybe pagefault_disable()
> is not needed.
>
> Best regards,
> --Edwin

Ok, I didn't see the context that way.
