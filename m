Return-Path: <linux-kernel-owner+w=401wt.eu-S1753235AbYCROI4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753235AbYCROI4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2008 10:08:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752455AbYCROIs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Mar 2008 10:08:48 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:53329 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752434AbYCROIr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2008 10:08:47 -0400
Subject: Re: [PATCH] [6/18] Add support to have individual hstates for each
	hugetlbfs mount
From: Adam Litke <agl@us.ibm.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, pj@sgi.com, linux-mm@kvack.org,
       nickpiggin@yahoo.com.au
In-Reply-To: <20080317015819.E7ECB1B41E0@basil.firstfloor.org>
References: <20080317258.659191058@firstfloor.org>
	 <20080317015819.E7ECB1B41E0@basil.firstfloor.org>
Content-Type: text/plain
Organization: IBM
Date: Tue, 18 Mar 2008 09:10:06 -0500
Message-Id: <1205849406.10849.89.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 2008-03-17 at 02:58 +0100, Andi Kleen wrote:
> - Add a new pagesize= option to the hugetlbfs mount that allows setting
> the page size
> - Set up pointers to a suitable hstate for the set page size option
> to the super block and the inode and the vma.
> - Change the hstate accessors to use this information
> - Add code to the hstate init function to set parsed_hstate for command
> line processing
> - Handle duplicated hstate registrations to the make command line user proof
> 
> Signed-off-by: Andi Kleen <ak@suse.de>

FWIW, I think this approach is definitely the way to go for supporting
multiple huge page sizes.

-- 
Adam Litke - (agl at us.ibm.com)
IBM Linux Technology Center

