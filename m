Return-Path: <linux-kernel-owner+w=401wt.eu-S1765285AbXEWLj5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765285AbXEWLj5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2007 07:39:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764169AbXEWLjs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 May 2007 07:39:48 -0400
Received: from an-out-0708.google.com ([209.85.132.248]:34254 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759272AbXEWLjr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2007 07:39:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=JELV8BhQY/t/6ms5LikzXuTZx0NVNuNqp9S/FjBnS0usJKw/rewEyut3gdw/DaCmlZQjN4aQjyC8A2erxoaDvHqtFiZrs26NfIh48JxWHePdYGgEV0vAZ1qZPQ+0ecFqtH0+bU+fNE3uKczl3xwr9PnV/kGpXWFa/+s46f6XKSU=
Message-ID: <4cefeab80705230439n6bbb1259le3c3b9704ce49b75@mail.gmail.com>
Date: Wed, 23 May 2007 17:09:46 +0530
From: "Nitin Gupta" <nitingupta910@gmail.com>
To: "Michael-Luke Jones" <mlj28@cam.ac.uk>
Subject: Re: [RFC] LZO de/compression support - take 3
Cc: linux-kernel@vger.kernel.org, "Richard Purdie" <richard@openedhand.com>,
       linux-mm-cc@laptop.org
In-Reply-To: <0F6CEFD7-86F2-4903-B4F7-F723DF88BE9A@cam.ac.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <4cefeab80705230127r58e8f9e1sa644092e95eb81eb@mail.gmail.com>
	 <0F6CEFD7-86F2-4903-B4F7-F723DF88BE9A@cam.ac.uk>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Michael,

On 5/23/07, Michael-Luke Jones <mlj28@cam.ac.uk> wrote:
> On 23 May 2007, at 09:27, Nitin Gupta wrote:
>
> > This contains LZO1X-1 compressor and LZO1X decompressor (safe and
> > standard version).
>
> I understand that the 'safe' decompression code is 'somewhat slower'
> and that decompressor performance is a key feature of this algorithm.
> However, I am concerned about the safety implications of including
> the 'unsafe' standard version in-kernel when likely uses include
> compression of network data, memory objects and so-on, all of which
> could in theory be maliciously modified.
>

The 'unsafe' version is still included since in some scenarios we have
guarantee that compressed data has not been modified (for e.g. where
we keep compressed data in memory only). So, in those cases there is
no need to go for slower 'safe' version. So, the version of
decompressor selected should be left to the user (kernel dev) only -
he should make sure that he is using the right version.

Cheers,
Nitin
