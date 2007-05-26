Return-Path: <linux-kernel-owner+w=401wt.eu-S1752701AbXEZKXo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752701AbXEZKXo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 May 2007 06:23:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750834AbXEZKXh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 May 2007 06:23:37 -0400
Received: from ppsw-4.csi.cam.ac.uk ([131.111.8.134]:56412 "EHLO
	ppsw-4.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750828AbXEZKXg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 May 2007 06:23:36 -0400
X-Cam-SpamDetails: Not scanned
X-Cam-AntiVirus: No virus found
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
In-Reply-To: <20070525104253.GA4555@ucw.cz>
References: <4cefeab80705230127r58e8f9e1sa644092e95eb81eb@mail.gmail.com> <0F6CEFD7-86F2-4903-B4F7-F723DF88BE9A@cam.ac.uk> <4cefeab80705230439n6bbb1259le3c3b9704ce49b75@mail.gmail.com> <624FD7A7-5552-415F-96D8-4353453EA2A3@cam.ac.uk> <4cefeab80705230703vdb3c414s250a61c4c2d70c51@mail.gmail.com> <1CF43BBC-79EF-449B-A398-AE374E399573@cam.ac.uk> <4cefeab80705230721i492b5f1ehfa2d775344b1c04e@mail.gmail.com> <20070523091601.f8c6b833.akpm@linux-foundation.org> <1179938960.5864.26.camel@localhost.localdomain> <4cefeab80705232104n54b23b9bi8b5db8e6a6dd1c0a@mail.gmail.com> <20070525104253.GA4555@ucw.cz>
Mime-Version: 1.0 (Apple Message framework v752.2)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <C7B006D9-08C2-4F44-9DCE-9753F7DB4D3F@cam.ac.uk>
Cc: Nitin Gupta <nitingupta910@gmail.com>,
       Richard Purdie <richard@openedhand.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-mm-cc@laptop.org
Content-Transfer-Encoding: 7bit
From: Michael-Luke Jones <mlj28@cam.ac.uk>
Subject: Re: [RFC] LZO de/compression support - take 3
Date: Sat, 26 May 2007 11:23:30 +0100
To: Pavel Machek <pavel@ucw.cz>
X-Mailer: Apple Mail (2.752.2)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 25 May 2007, at 11:42, Pavel Machek wrote:
> What is the performance difference between safe and unsafe version?

On 24 May 2007, at 23:26, Richard Purdie wrote:
> For my minilzo kernel patch, the safe version showed a 7.2%  
> performance
> hit.

The conclusion seemed to be that we should drop the 'unsafe' version  
on this basis.

Michael-Luke
