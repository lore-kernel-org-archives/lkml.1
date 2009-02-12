Return-Path: <linux-kernel-owner+w=401wt.eu-S1760401AbZBLSnf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760401AbZBLSnf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Feb 2009 13:43:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760072AbZBLSnU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Feb 2009 13:43:20 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:36238 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759894AbZBLSnT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Feb 2009 13:43:19 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <49946DB4.5000705@s5r6.in-berlin.de>
Date: Thu, 12 Feb 2009 19:43:00 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.19) Gecko/20090104 SeaMonkey/1.1.14
MIME-Version: 1.0
To: Boaz Harrosh <bharrosh@panasas.com>
CC: Harvey Harrison <harvey.harrison@gmail.com>,
       Christoph Hellwig <hch@lst.de>, linux-kernel@vger.kernel.org
Subject: Re: get/put unaligned helpers
References: <20090211143521.GA18866@lst.de> <1234367339.5481.3.camel@brick> <4993E2CA.1070408@panasas.com>
In-Reply-To: <4993E2CA.1070408@panasas.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Boaz Harrosh wrote:
> When all this is done do you intend to also export
> the unaligned.h headers to user-mode just like the aligned Endian helpers?

Neither the aligned nor unaligned endian conversion helpers are
interfaces between kernel and userland, hence should not be exported.
Export of the aligned ones is a mistake of the past.  IIRC there were
different opinions on whether this mistake should be corrected; it seems
it won't.
-- 
Stefan Richter
-=====-==--= --=- -==--
http://arcgraph.de/sr/
