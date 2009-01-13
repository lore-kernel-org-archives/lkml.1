Return-Path: <linux-kernel-owner+w=401wt.eu-S1760110AbZAMOlR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760110AbZAMOlR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 09:41:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755553AbZAMOk5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 09:40:57 -0500
Received: from rcsinet12.oracle.com ([148.87.113.124]:25187 "EHLO
	rgminet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753871AbZAMOk4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 09:40:56 -0500
Subject: Re: Warning and BUG with btrfs and corrupted image
From: Chris Mason <chris.mason@oracle.com>
To: Eric Sesterhenn <snakebyte@gmx.de>
Cc: linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org
In-Reply-To: <20090113142147.GE16333@alice>
References: <20090113142147.GE16333@alice>
Content-Type: text/plain
Date: Tue, 13 Jan 2009 09:40:43 -0500
Message-Id: <1231857643.29164.28.camel@think.oraclecorp.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt704.oracle.com [141.146.40.82]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090207.496CA7EE.00DC:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-01-13 at 15:21 +0100, Eric Sesterhenn wrote:
> Hi,
> 
> when mounting an intentionally corrupted btrfs filesystem i get the
> following warning and bug message. The image can be found here
> www.cccmz.de/~snakebyte/btrfs.2.img.bck.bz2

Thanks for looking at things

Aside from catching checksumming errors, we're not quite ready for
fuzzer style attacks.  The code will be hardened for this but it isn't
yet.

-chris


