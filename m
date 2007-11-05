Return-Path: <linux-kernel-owner+w=401wt.eu-S1756214AbXKEOrV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756214AbXKEOrV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2007 09:47:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751183AbXKEOrO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Nov 2007 09:47:14 -0500
Received: from ug-out-1314.google.com ([66.249.92.169]:16049 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751087AbXKEOrN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2007 09:47:13 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=SVyabmwzsNjKGJTwGgGTV/krEVm63CSrohdbxurUdYS0jkbOD3Gs9EeuV3Ot5X/3MO5U35I8Xh23vdva3chTYfSqXVZds8tUaxJ2rRdHYE6GXF2hjtKZJEpGHqhzSAQQOxhZx8c11WfQrpa7DR2zd9naa+QfHlxUM5e00sXHyqA=
From: Denys Vlasenko <vda.linux@googlemail.com>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [patch] PID namespaces
Date: Mon, 5 Nov 2007 14:47:01 +0000
User-Agent: KMail/1.9.1
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Dave Hansen <haveblue@us.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Pavel Emelyanov <xemul@openvz.org>, Ulrich Drepper <drepper@redhat.com>,
       linux-kernel@vger.kernel.org,
       "Dinakar Guniguntala [imap]" <dino@in.ibm.com>,
       Sripathi Kodi <sripathik@in.ibm.com>
References: <4729E7E4.8070208@openvz.org> <alpine.LFD.0.999.0711031535450.15101@woody.linux-foundation.org> <20071104103851.GA14317@elte.hu>
In-Reply-To: <20071104103851.GA14317@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711051447.02232.vda.linux@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 04 November 2007 10:38, Ingo Molnar wrote:
> I.e. keep the namespace functionality but use a modulo 1.000.000 base 
> for the PIDs so that it all looks nicer to the user. Minimal visibility 
> difference but maximum compatibility. (The resulting limits are 
> reasonable: 1 million tasks per container and 4 million containers on a 
> single 32-bit box.) We could still restrict cross-namespace API use but 

4 thousand, not 4 million.
--
vda
