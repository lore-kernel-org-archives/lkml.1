Return-Path: <linux-kernel-owner+w=401wt.eu-S1761859AbXK2P4W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761859AbXK2P4W (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2007 10:56:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752863AbXK2P4P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Nov 2007 10:56:15 -0500
Received: from mtagate8.de.ibm.com ([195.212.29.157]:60639 "EHLO
	mtagate8.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754645AbXK2P4O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2007 10:56:14 -0500
Subject: Re: [patch 06/10] s390: Use generic percpu
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
Reply-To: schwidefsky@de.ibm.com
To: Christoph Lameter <clameter@sgi.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
In-Reply-To: <20071128211527.373111512@sgi.com>
References: <20071128210926.008783214@sgi.com>
	 <20071128211527.373111512@sgi.com>
Content-Type: text/plain
Organization: IBM Corporation
Date: Thu, 29 Nov 2007 16:56:01 +0100
Message-Id: <1196351761.23168.2.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-11-28 at 13:09 -0800, Christoph Lameter wrote:
> s390 has a special way to determine the pointer to a per cpu area
> plus there is a way to access the base of the per cpu area of the
> currently executing processor.
> 
> Note: I had to do a minor change to ASM code. Please check that
> this was done right.

Hi Christoph,

after fixing the trainwreck with Gregs kset changes I've got rc3-mm2
compiled with your percpu patches. The new s390 percpu code works fine:

Acked-by: Martin Schwidefsky <schwidefsky@de.ibm.com>

-- 
blue skies,
  Martin.

"Reality continues to ruin my life." - Calvin.


