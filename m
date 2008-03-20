Return-Path: <linux-kernel-owner+w=401wt.eu-S1758272AbYCTSjW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758272AbYCTSjW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2008 14:39:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755881AbYCTSjP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Mar 2008 14:39:15 -0400
Received: from static-71-162-243-5.phlapa.fios.verizon.net ([71.162.243.5]:49435
	"EHLO grelber.thyrsus.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753807AbYCTSjO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2008 14:39:14 -0400
From: Rob Landley <rob@landley.net>
Organization: Boundaries Unlimited
To: Ian Abbott <abbotti@mev.co.uk>
Subject: Re: [PATCH] Corrections to Documentation/rbtree.txt
Date: Thu, 20 Mar 2008 13:39:18 -0500
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: linux-kernel@vger.kernel.org
References: <47E282F5.6090703@mev.co.uk>
In-Reply-To: <47E282F5.6090703@mev.co.uk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803201339.18618.rob@landley.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 20 March 2008 10:29:57 Ian Abbott wrote:
> From: Ian Abbott <abbotti@mev.co.uk>
>
> The description of the rb_entry() macro in Documentation/rbtree.txt seems
> incorrect. This patch improves it (hopefully).  Also I changed the example
> code to call the previous 'my_search()' example instead of an undefined
> 'mysearch()'.

I have no objection to the patch (and the my_search thing seems like an 
obvious typo), but is there a reason to prefer rb_entry() rather than 
container_of()?  If so, the rationale might be a good thing to add to the 
documentation...

Rob
-- 
"One of my most productive days was throwing away 1000 lines of code."
  - Ken Thompson.
