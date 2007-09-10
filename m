Return-Path: <linux-kernel-owner+w=401wt.eu-S933377AbXIJWhx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933377AbXIJWhx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2007 18:37:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932774AbXIJWhp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Sep 2007 18:37:45 -0400
Received: from nz-out-0506.google.com ([64.233.162.236]:13826 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932715AbXIJWho (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2007 18:37:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=VjMjtDkXeIAc9AvQWT+0a/HrV4BdhmTu6nwYelklURDtdBNT/bLQcRIxMPZIITVTQK+B0w9qNVhdjSj9XgsRq8ZobFYw0DMpoqY27Jn9XszqjvTQtNn6ZJU7Pzo0B12hVvCZoxO5TsdBzxFOlFVIB3YHB7/vX9MamG5F9/cKBT8=
Message-ID: <b647ffbd0709101537l9af4dc8x743b25c96e0f5235@mail.gmail.com>
Date: Tue, 11 Sep 2007 00:37:43 +0200
From: "Dmitry Adamushko" <dmitry.adamushko@gmail.com>
To: vatsa@linux.vnet.ibm.com
Subject: Re: [PATCH] Hookup group-scheduler with task container infrastructure
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       ckrm-tech@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       containers@lists.osdl.org, "Jan Engelhardt" <jengelh@computergmbh.de>,
       "Ingo Molnar" <mingo@elte.hu>
In-Reply-To: <20070910174649.GA16222@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070910171049.GA16048@linux.vnet.ibm.com>
	 <Pine.LNX.4.64.0709101903220.5368@fbirervta.pbzchgretzou.qr>
	 <20070910172334.GB19100@linux.vnet.ibm.com>
	 <20070910102259.dc45a481.akpm@linux-foundation.org>
	 <20070910174649.GA16222@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/09/2007, Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com> wrote:
> On Mon, Sep 10, 2007 at 10:22:59AM -0700, Andrew Morton wrote:
> > objection ;)  "cpuctlr" isn't memorable.  Kernel code is write-rarely,
> > read-often.  "cpu_controller", please.  The extra typing is worth it ;)
>
> Ok! Here's the modified patch (against 2.6.23-rc4-mm1).

as everyone seems to be in a quest for a better name... I think, the
obvious one would be just 'group_sched'.


-- 
Best regards,
Dmitry Adamushko
