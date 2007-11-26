Return-Path: <linux-kernel-owner+w=401wt.eu-S1755825AbXKZK2s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755825AbXKZK2s (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2007 05:28:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754785AbXKZK2a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Nov 2007 05:28:30 -0500
Received: from rv-out-0910.google.com ([209.85.198.187]:24419 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754552AbXKZK22 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2007 05:28:28 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=ogR+s1a6jRuw5oRr8ljA/ROj0NJHoVEyyOaIX3IYsFAHWBLa1u+lyCGwbVRVIUxpvAtWbM5fnQVDoarXW80W8zG4mO8A62fMwqcJvE6HXBlPEkECf+XEWWipHdxj8x3STi63ALm6pCZf1ftnJhpdCuem6uHGvmh3S0Tj/LyKqxA=
Message-ID: <b25c3fa70711260228u2524e26br8dab5105bd3ae6db@mail.gmail.com>
Date: Mon, 26 Nov 2007 19:28:28 +0900
From: "Joonwoo Park" <joonwpark81@gmail.com>
To: "Robert P. J. Day" <rpjday@crashcourse.ca>
Subject: Re: [PATCH 1/4] xfrm_hash: kmalloc + memset conversion to kzalloc
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <alpine.LFD.0.9999.0711260405110.362@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <007c01c8300b$176975a0$9c94fea9@jason>
	 <alpine.LFD.0.9999.0711260405110.362@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>
> i believe the more common standard for the above is:
>
>  else if (hashdist) {
>
> to reduce the level of overall indentation, no?
>

No, it was.
Because there was a memset in that indentation, but I made it by
removing memset.

Thanks.
Joonwoo
