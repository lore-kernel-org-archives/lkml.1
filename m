Return-Path: <linux-kernel-owner+w=401wt.eu-S970359AbXFHQU7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S970359AbXFHQU7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 12:20:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S970323AbXFHQRi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 12:17:38 -0400
Received: from fall-lakeland.atl.sa.earthlink.net ([207.69.195.103]:51882 "EHLO
	fall-lakeland.atl.sa.earthlink.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S970319AbXFHQRh convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 12:17:37 -0400
From: Rich Chase <rac47.02@engalumni.colostate.edu>
Reply-To: rac47.02@engalumni.colostate.edu
Organization: Independent Thinkers R Us
To: linux-kernel@vger.kernel.org
Subject: missing elfconfig.h
Date: Fri, 8 Jun 2007 09:08:36 -0400
User-Agent: KMail/1.9.4
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200706080908.37044.rac47.02@engalumni.colostate.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

An Apparent bug:
version 2.6.21.3
missing the file ./scripts/mod/elfconfig.h

I noticed this when trying to compile a 3rd party 
module. Maybe this is intended. Not sure.

I discovered this when I attempted to compile modpost.c 
in the same directory. The following is the output:

#> make modpost
cc     modpost.c   -o modpost
In file included from modpost.c:15:
modpost.h:12:23: error: elfconfig.h: No such file or 
directory
modpost.c: In function ‘handle_modversions’:
modpost.c:436: error: ‘MODULE_SYMBOL_PREFIX’ undeclared 
(first use in this function)
modpost.c:436: error: (Each undeclared identifier is 
reported only once
modpost.c:436: error: for each function it appears in.)
modpost.c:436: error: expected ‘)’ before string 
constant
modpost.c:436: error: too few arguments to 
function ‘memcmp’
modpost.c:438: error: expected ‘)’ before string 
constant
modpost.c:451: error: expected ‘)’ before string 
constant
modpost.c:482: error: expected ‘)’ before string 
constant
modpost.c:482: error: too few arguments to 
function ‘memcmp’
modpost.c:483: error: expected ‘)’ before string 
constant
modpost.c:486: error: expected ‘)’ before string 
constant
modpost.c:488: error: expected ‘)’ before string 
constant
make: *** [modpost] Error 1


Regards,
Rich Chase
