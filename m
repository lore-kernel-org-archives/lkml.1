Return-Path: <linux-kernel-owner+w=401wt.eu-S1764549AbXEWOVx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764549AbXEWOVx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2007 10:21:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755343AbXEWOVq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 May 2007 10:21:46 -0400
Received: from an-out-0708.google.com ([209.85.132.249]:3779 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755214AbXEWOVp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2007 10:21:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Bl7ZK8f1rX7gA+OREsuciNuX1IoIMf/QDAlwc5pJhT3bJizJhIYCF/OFiiruqmfUqA3YEzD/rRRymhXAJRjyb4fOrZ45dPTVByqRU2ktH4fT5BexXTV0GHF9rztP1LM7OqV/c7PJ2DKLPy5a5t/YJbO44FMLWJhpDUpErcYizFE=
Message-ID: <4cefeab80705230721i492b5f1ehfa2d775344b1c04e@mail.gmail.com>
Date: Wed, 23 May 2007 19:51:44 +0530
From: "Nitin Gupta" <nitingupta910@gmail.com>
To: "Michael-Luke Jones" <mlj28@cam.ac.uk>
Subject: Re: [RFC] LZO de/compression support - take 3
Cc: linux-kernel@vger.kernel.org, "Richard Purdie" <richard@openedhand.com>,
       linux-mm-cc@laptop.org
In-Reply-To: <1CF43BBC-79EF-449B-A398-AE374E399573@cam.ac.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <4cefeab80705230127r58e8f9e1sa644092e95eb81eb@mail.gmail.com>
	 <0F6CEFD7-86F2-4903-B4F7-F723DF88BE9A@cam.ac.uk>
	 <4cefeab80705230439n6bbb1259le3c3b9704ce49b75@mail.gmail.com>
	 <624FD7A7-5552-415F-96D8-4353453EA2A3@cam.ac.uk>
	 <4cefeab80705230703vdb3c414s250a61c4c2d70c51@mail.gmail.com>
	 <1CF43BBC-79EF-449B-A398-AE374E399573@cam.ac.uk>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/23/07, Michael-Luke Jones <mlj28@cam.ac.uk> wrote:
> On 23 May 2007, at 15:03, Nitin Gupta wrote:
>
> >> Perhaps a rename is in order:
> >> lzo1x_decompress() => lzo1x_decompress_unsafe()
> >> lzo1x_decompress_safe => lzo1x_decompress()
> >
> > Or perhaps make reiserfs use _safe() instead - I think Richard has
> > already submitted patch for same.
>
> If someone's already made this mistake once, then it'll happen again.
> In-kernel memory corruption is no fun.
>
> Safe/Secure == Default

If I rename 'nonsafe' version as such then it will seem like its a
'broken' implementation which is not the case. If somebody is upto
including compression he must be having head to use the right
decompress version depending on this scenario :-)

- Nitin



>
> Michael-Luke
>
>
