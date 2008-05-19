Return-Path: <linux-kernel-owner+w=401wt.eu-S1762644AbYESSM3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762644AbYESSM3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 14:12:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758498AbYESSMW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 14:12:22 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:53211 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755278AbYESSMV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 14:12:21 -0400
Date: Mon, 19 May 2008 20:12:58 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: lkml <linux-kernel@vger.kernel.org>, akpm <akpm@linux-foundation.org>
Subject: Re: [PATCH] kernel-doc: allow unnamed bit-fields
Message-ID: <20080519181258.GB22931@uranus.ravnborg.org>
References: <20080516154552.eadc454e.randy.dunlap@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080516154552.eadc454e.randy.dunlap@oracle.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 16, 2008 at 03:45:52PM -0700, Randy Dunlap wrote:
> From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> Allow for unnamed bit-fields and skip them instead of printing an
> erroneous warning message for them, such as:
> 
> Warning(include/asm-s390/cio.h:103): No description found for parameter 'u32'
> 
> which contains:
> 
> struct tm_scsw {
> 	u32 :1;
> 
> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>

Added to kbuild-fixes.

	Sam
