Return-Path: <linux-kernel-owner+w=401wt.eu-S1751529Ab0AJCHg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751529Ab0AJCHg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jan 2010 21:07:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751242Ab0AJCHf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Jan 2010 21:07:35 -0500
Received: from mail-iw0-f194.google.com ([209.85.223.194]:65139 "EHLO
	mail-iw0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751196Ab0AJCHe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jan 2010 21:07:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type;
        b=YBwgLVr3f+CyuKdZRT3rX17bRGxkvBuHykBb0BYuyzi+iZVGkIUwGJ4dD+MrV8RrPP
         R8xg+0GeKZla1ngltP4oedRec+54b6Tz8/CDA99QJhzvczHun/1wPkdvgFo8/Dsw+I01
         pXLLdTHIlocFpLCjdXAxLk6E3U2iPH1ZW5Pv0=
MIME-Version: 1.0
In-Reply-To: <20100109164240.43b21247@infradead.org>
References: <alpine.LNX.2.00.1001071941470.1363@localhost.localdomain> 
	<20100108171513.GB22713@ldl.fc.hp.com> <20100109134352.3dedd4ea@infradead.org> 
	<alpine.LNX.2.00.1001100155370.1325@localhost.localdomain> 
	<20100109160836.26a344a9@infradead.org> <alpine.LNX.2.00.1001100226570.1325@localhost.localdomain> 
	<20100109164240.43b21247@infradead.org>
From: Ray Lee <ray-lk@madrabbit.org>
Date: Sat, 9 Jan 2010 18:07:14 -0800
X-Google-Sender-Auth: 86f32908f35f37db
Message-ID: <2c0942db1001091807k542b1052s96111775d6431bd0@mail.gmail.com>
Subject: Re: High cpu temperature with 2.6.32, bisection shows commit 69d258 
	(fwd)
To: Arjan van de Ven <arjan@infradead.org>
Cc: Dimitrios Apostolou <jimis@gmx.net>, Alex Chiang <achiang@hp.com>,
       Len Brown <lenb@kernel.org>, Bjorn Helgaas <bjorn.helgaas@hp.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Yinghai Lu <yinghai@kernel.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 9, 2010 at 4:42 PM, Arjan van de Ven <arjan@infradead.org> wrote:
> basically it appears that your machine, when the kernel asks for C2,
> exits C2 immediately again.
>
> The old algorithm somehow caught this and stopped asking for C2 most of
> the time; the new algorithm doesn't see any activity and asks for C2
> again.

This change of behavior will certainly bite more users out there. Is
there any way we can detect the systems that aren't honoring the C2
request and limit back to C1?
