Return-Path: <linux-kernel-owner+w=401wt.eu-S1758119AbYCEQdK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758119AbYCEQdK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 11:33:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753040AbYCEQc4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 11:32:56 -0500
Received: from e36.co.us.ibm.com ([32.97.110.154]:47315 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751294AbYCEQcz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 11:32:55 -0500
Subject: Re: [RFC][PATCH] make /proc/pid/pagemap work with huge pages and
	return page size
From: Dave Hansen <haveblue@us.ibm.com>
To: Hans Rosenfeld <hans.rosenfeld@amd.com>
Cc: Matt Mackall <mpm@selenic.com>, linux-kernel@vger.kernel.org,
       Adam Litke <aglitke@gmail.com>, nacc <nacc@linux.vnet.ibm.com>,
       Jon Tollefson <kniht@linux.vnet.ibm.com>,
       Adam Litke <agl@linux.vnet.ibm.com>
In-Reply-To: <20080305160020.GA27109@escobedo.amd.com>
References: <1203791461.11305.135.camel@nimitz.home.sr71.net>
	 <20080225120951.GA5963@escobedo.amd.com>
	 <1203964750.28196.7.camel@nimitz.home.sr71.net>
	 <20080226202533.GD5963@escobedo.amd.com>
	 <1204134244.5207.28.camel@nimitz.home.sr71.net>
	 <20080228120055  <20080305160020.GA27109@escobedo.amd.com>
Content-Type: text/plain
Date: Wed, 05 Mar 2008 08:32:46 -0800
Message-Id: <1204734766.23655.32.camel@nimitz.home.sr71.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 2008-03-05 at 17:00 +0100, Hans Rosenfeld wrote:
> 
> There are a few reserved bits in the pte part of the union that could
> be
> used to extend the pfn or add more status bits in future (a ronly bit,

Were you able to find any other instances of these bitfields being used
for kernel<->user communication?  I thought you were going to check to
see if we could depend on the layout, or if it changed between
compilers.

-- Dave

