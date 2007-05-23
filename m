Return-Path: <linux-kernel-owner+w=401wt.eu-S1762613AbXEWKyC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762613AbXEWKyC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2007 06:54:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758660AbXEWKxy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 May 2007 06:53:54 -0400
Received: from ppsw-7.csi.cam.ac.uk ([131.111.8.137]:60194 "EHLO
	ppsw-7.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758439AbXEWKxx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2007 06:53:53 -0400
X-Cam-SpamDetails: Not scanned
X-Cam-AntiVirus: No virus found
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
In-Reply-To: <4cefeab80705230127r58e8f9e1sa644092e95eb81eb@mail.gmail.com>
References: <4cefeab80705230127r58e8f9e1sa644092e95eb81eb@mail.gmail.com>
Mime-Version: 1.0 (Apple Message framework v752.2)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <0F6CEFD7-86F2-4903-B4F7-F723DF88BE9A@cam.ac.uk>
Cc: linux-kernel@vger.kernel.org, "Richard Purdie" <richard@openedhand.com>,
       linux-mm-cc@laptop.org
Content-Transfer-Encoding: 7bit
From: Michael-Luke Jones <mlj28@cam.ac.uk>
Subject: Re: [RFC] LZO de/compression support - take 3
Date: Wed, 23 May 2007 11:53:37 +0100
To: Nitin Gupta <nitingupta910@gmail.com>
X-Mailer: Apple Mail (2.752.2)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 23 May 2007, at 09:27, Nitin Gupta wrote:

> This contains LZO1X-1 compressor and LZO1X decompressor (safe and
> standard version).

I understand that the 'safe' decompression code is 'somewhat slower'  
and that decompressor performance is a key feature of this algorithm.  
However, I am concerned about the safety implications of including  
the 'unsafe' standard version in-kernel when likely uses include  
compression of network data, memory objects and so-on, all of which  
could in theory be maliciously modified.

I'm no kernel or programming expert, so I may be off the mark with  
this one. To me, at least, even if the answer is 'no, there isn't a  
problem' that's still a valuable clarification :)

Thanks,

Michael-Luke Jones
[please cc me on replies as I am not subscribed to lkml]
