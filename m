Return-Path: <linux-kernel-owner+w=401wt.eu-S1761570AbZBLXmw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761570AbZBLXmw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Feb 2009 18:42:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753493AbZBLXmk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Feb 2009 18:42:40 -0500
Received: from THUNK.ORG ([69.25.196.29]:41671 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750742AbZBLXmj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Feb 2009 18:42:39 -0500
Date: Thu, 12 Feb 2009 17:00:37 -0500
From: Theodore Tso <tytso@mit.edu>
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
       linux-next@vger.kernel.org
Subject: Re: [PATCH] ext4: Initialize list properly
Message-ID: <20090212220037.GG6922@mini-me.lan>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
	linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
	linux-next@vger.kernel.org
References: <a4423d670902100906q36e7f36fo53ba2060f5644303@mail.gmail.com> <1234422331-32766-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1234422331-32766-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 12, 2009 at 12:35:31PM +0530, Aneesh Kumar K.V wrote:
> We need to initialize the list_head properly before we add
> them to the any list. Otherwise with list debug on we get
> list corruption warnings.
> 
> Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>

Added to the ext4 patch queue with a slight adjustment in the patch
commit for readability issues:

   When creating a new ext4_prealloc_space structure, we have to
   initialize its list_head pointers before we add them to any prealloc
   lists.  Otherwise, with list debug enabled, we will get list
   corruption warnings.

   Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
   Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>

						- Ted
