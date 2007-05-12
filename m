Return-Path: <linux-kernel-owner+w=401wt.eu-S1758450AbXELKP1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758450AbXELKP1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 May 2007 06:15:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755575AbXELKPR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 May 2007 06:15:17 -0400
Received: from nz-out-0506.google.com ([64.233.162.233]:10766 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755242AbXELKPP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 May 2007 06:15:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=Fpi8ys9RkSraSlcHfvxPO/gS76KQBKDKjiLWI+BsEtDh2W9S6Wx3VKNg70zT1V6fR03oSvWKiEh6O3F32TIAdHWw0moBZtbs8f/Eq0XjMlOAiwdgPNTbyo6QnzFeQA2/I290jaIBgfV1F95KX6ZcY5acKxPmRV5uyX1AQUiGZ/8=
Message-ID: <84144f020705120315i47b033e9w702266ab4d0631bc@mail.gmail.com>
Date: Sat, 12 May 2007 13:15:14 +0300
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Cyrill Gorcunov" <gorcunov@gmail.com>
Subject: Re: [PATCH] UDF: check for allocated memory for inode data
Cc: "Christoph Hellwig" <hch@infradead.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "Ben Fennema" <bfennema@falcon.csc.calpoly.edu>,
       "Jan Kara" <jack@ucw.cz>
In-Reply-To: <20070512100949.GC8337@cvg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070510140000.GA12399@cvg>
	 <20070510154640.c0299a52.akpm@linux-foundation.org>
	 <20070511072939.GA25727@infradead.org> <20070511090127.GD9444@cvg>
	 <20070511103956.GA30896@infradead.org> <20070512100949.GC8337@cvg>
X-Google-Sender-Auth: cb5f09e10bf4f6e3
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Cyrill

On 5/12/07, Cyrill Gorcunov <gorcunov@gmail.com> wrote:
> you know I've got a question (may be it's stupid) - what a
> sense to discard UDF_I_* macroses? I mean as I see they
> don't slow down execution of the code...

They make the code harder to read and maintain.
