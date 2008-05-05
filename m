Return-Path: <linux-kernel-owner+w=401wt.eu-S1756731AbYEENmp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756731AbYEENmp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 09:42:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752431AbYEENmg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 09:42:36 -0400
Received: from py-out-1112.google.com ([64.233.166.179]:26438 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752707AbYEENmf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 09:42:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=hjdytrls39XRQoem6hEWgdKnm3GCP4zF0LQccs62LGtangpFKaDdqiQeVsWaXMXGwrCWnSkmUD81Kzxj7lOLKQS/7/st/RD6pfZVDvUxvO7oTy+20Rg3PlFA4p1H7ebBDh5XM7uOtsCXJAuPduH9jLnbImPm7WQd4201ZbqVP5A=
Message-ID: <84144f020805050642p1e0ca224r9c1a92e899fddfe3@mail.gmail.com>
Date: Mon, 5 May 2008 16:42:24 +0300
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Andi Kleen" <andi@firstfloor.org>
Subject: Re: [PATCH] i386: Execute stack overflow warning on interrupt stack II
Cc: "Thomas Gleixner" <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
       mingo@elte.hu, sandeen@sandeen.net
In-Reply-To: <481F0BCD.8020306@firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080502091806.GA26062@basil.nowhere.org>
	 <20080502094543.GA11114@basil.nowhere.org>
	 <alpine.LFD.1.10.0805051135530.3318@apollo.tec.linutronix.de>
	 <481EDEC5.10000@firstfloor.org>
	 <alpine.LFD.1.10.0805051434200.3318@apollo.tec.linutronix.de>
	 <481F0BCD.8020306@firstfloor.org>
X-Google-Sender-Auth: 4478166ef056db86
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andi,

On Mon, May 5, 2008 at 4:29 PM, Andi Kleen <andi@firstfloor.org> wrote:
>  > Err, it checks the process stack when 4KSTACKS=n
>
>  Ok then please add the two changes if you feel strongly about that
>  (to the latest version I sent).
>
>  You always edit my patches anyways (usually driving me crazy when I have
>  dependent patches because nothing applies anymore when all the variables
>  got renamed like you often do) so I don't see any reason why you can't
>  do that here.

Heh, do you mean to say that all this time I should have just asked
Andrew to fix all the patches I've submitted rather take the trouble
to do that myself after the review? ;-)
