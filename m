Return-Path: <linux-kernel-owner+w=401wt.eu-S1752034AbYKJTcY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752034AbYKJTcY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2008 14:32:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751018AbYKJTcM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Nov 2008 14:32:12 -0500
Received: from lazybastard.de ([212.112.238.170]:37238 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750989AbYKJTcL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2008 14:32:11 -0500
Date: Mon, 10 Nov 2008 20:31:36 +0100
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Christoph Hellwig <hch@infradead.org>, Theodore Tso <tytso@mit.edu>,
       Peter Staubach <staubach@redhat.com>,
       Christian Borntraeger <borntraeger@de.ibm.com>,
       linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH]: ext4: fix big endian
Message-ID: <20081110193135.GA18378@logfs.org>
References: <200811061600.54264.borntraeger@de.ibm.com> <200811061651.49602.borntraeger@de.ibm.com> <49131601.50407@redhat.com> <20081106163846.GA1381@infradead.org> <20081106173327.GF18939@mit.edu> <20081106173944.GA23398@infradead.org> <20081108223504.GA1301@logfs.org> <1226340578.22742.4.camel@brick>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1226340578.22742.4.camel@brick>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 10 November 2008 10:09:38 -0800, Harvey Harrison wrote:
> 
> I'd say that it's getting close to just being able to turn it on by
> default.  A lot of the really verbose offenders have been annotated
> now, drivers/ieee1394, drivers/scsi, drivers/message and some of the
> older areas of drivers/net will get noisy, I was going to send an RFC
> for 2.6.29 and continue to chip away at the output.

My argument for the define is that it doesn't hurt much if endian checks
are enabled globally, but helps a lot if they are not.  So until it is
clear that endian checks will be enabled, it may still be a good idea.

Jörn

-- 
It's not whether you win or lose, it's how you place the blame.
-- unknown
