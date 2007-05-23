Return-Path: <linux-kernel-owner+w=401wt.eu-S934330AbXEWOKV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934330AbXEWOKV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2007 10:10:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757562AbXEWOKL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 May 2007 10:10:11 -0400
Received: from ppsw-7.csi.cam.ac.uk ([131.111.8.137]:32917 "EHLO
	ppsw-7.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757348AbXEWOKJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2007 10:10:09 -0400
X-Cam-SpamDetails: Not scanned
X-Cam-AntiVirus: No virus found
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
In-Reply-To: <4cefeab80705230703vdb3c414s250a61c4c2d70c51@mail.gmail.com>
References: <4cefeab80705230127r58e8f9e1sa644092e95eb81eb@mail.gmail.com> <0F6CEFD7-86F2-4903-B4F7-F723DF88BE9A@cam.ac.uk> <4cefeab80705230439n6bbb1259le3c3b9704ce49b75@mail.gmail.com> <624FD7A7-5552-415F-96D8-4353453EA2A3@cam.ac.uk> <4cefeab80705230703vdb3c414s250a61c4c2d70c51@mail.gmail.com>
Mime-Version: 1.0 (Apple Message framework v752.2)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <1CF43BBC-79EF-449B-A398-AE374E399573@cam.ac.uk>
Cc: linux-kernel@vger.kernel.org, "Richard Purdie" <richard@openedhand.com>,
       linux-mm-cc@laptop.org
Content-Transfer-Encoding: 7bit
From: Michael-Luke Jones <mlj28@cam.ac.uk>
Subject: Re: [RFC] LZO de/compression support - take 3
Date: Wed, 23 May 2007 15:10:03 +0100
To: Nitin Gupta <nitingupta910@gmail.com>
X-Mailer: Apple Mail (2.752.2)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 23 May 2007, at 15:03, Nitin Gupta wrote:

>> Perhaps a rename is in order:
>> lzo1x_decompress() => lzo1x_decompress_unsafe()
>> lzo1x_decompress_safe => lzo1x_decompress()
>
> Or perhaps make reiserfs use _safe() instead - I think Richard has
> already submitted patch for same.

If someone's already made this mistake once, then it'll happen again.  
In-kernel memory corruption is no fun.

Safe/Secure == Default

Michael-Luke

