Return-Path: <linux-kernel-owner+w=401wt.eu-S1759291AbXEYMA7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759291AbXEYMA7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2007 08:00:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752007AbXEYMAx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 May 2007 08:00:53 -0400
Received: from ppsw-2.csi.cam.ac.uk ([131.111.8.132]:60609 "EHLO
	ppsw-2.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751470AbXEYMAw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2007 08:00:52 -0400
X-Cam-SpamDetails: Not scanned
X-Cam-AntiVirus: No virus found
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
In-Reply-To: <4cefeab80705250445m51736a9aj8c89af893d8c242c@mail.gmail.com>
References: <4cefeab80705250445m51736a9aj8c89af893d8c242c@mail.gmail.com>
Mime-Version: 1.0 (Apple Message framework v752.2)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <C61A38DB-3463-4CCC-B2A6-28DA9344AB1E@cam.ac.uk>
Cc: linux-kernel@vger.kernel.org, linux-mm-cc@laptop.org,
       "Richard Purdie" <richard@openedhand.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Satyam Sharma" <satyam.sharma@gmail.com>,
       "Andrey Panin" <pazke@donpac.ru>, "Bret Towe" <magnade@gmail.com>
Content-Transfer-Encoding: 7bit
From: Michael-Luke Jones <mlj28@cam.ac.uk>
Subject: Re: [RFC] LZO de/compression support - take 4
Date: Fri, 25 May 2007 13:00:44 +0100
To: Nitin Gupta <nitingupta910@gmail.com>
X-Mailer: Apple Mail (2.752.2)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 25 May 2007, at 12:45, Nitin Gupta wrote:

> Hi,
>
> This is kernel port of LZO1X compressor and LZO1X decompressor (safe
> version only).

Hey there,

It's looking better now. Just wondering if you might want to separate  
out the Kconfig options for lzo compress / decompress so that it's  
orthogonal with zlib's inflate and deflate support. Read only  
filesystems only have to decompress, for example.

M-L
