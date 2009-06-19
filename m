Return-Path: <linux-kernel-owner+w=401wt.eu-S1757376AbZFSVXU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757376AbZFSVXU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jun 2009 17:23:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752427AbZFSVXM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Jun 2009 17:23:12 -0400
Received: from acsinet12.oracle.com ([141.146.126.234]:47752 "EHLO
	acsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751908AbZFSVXM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jun 2009 17:23:12 -0400
Message-ID: <4A3C00E7.9020808@oracle.com>
Date: Fri, 19 Jun 2009 14:19:35 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Marcel Holtmann <marcel@holtmann.org>
CC: Krzysztof Halasa <khc@pm.waw.pl>, Dave Airlie <airlied@linux.ie>,
       Keith Packard <keithp@keithp.com>, linux-kernel@vger.kernel.org,
       dri-devel@lists.sourceforge.net
Subject: Re: Trivial fixes for drivers/gpu/drm/i915/
References: <m34ouc55ka.fsf@intrepid.localdomain> <1245443718.15367.46.camel@violet>
In-Reply-To: <1245443718.15367.46.camel@violet>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: abhmt001.oracle.com [141.146.116.10]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090209.4A3C01A6.002D:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Marcel Holtmann wrote:
> Hi Krzysztof,
> 
>> size_t is (some sort of) int on x86-32 and long on x86-64, eliminate
>> compiler warnings by casting to long.
> 
> just using %zd or %zu would do the same trick and avoid stupid casts.

I.e., using %zd or %zu is the preferred fix.

-- 
~Randy
LPC 2009, Sept. 23-25, Portland, Oregon
http://linuxplumbersconf.org/2009/
