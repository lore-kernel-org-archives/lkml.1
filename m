Return-Path: <linux-kernel-owner+w=401wt.eu-S932523AbXBNT4n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932523AbXBNT4n (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Feb 2007 14:56:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932517AbXBNT4n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Feb 2007 14:56:43 -0500
Received: from mx1.redhat.com ([66.187.233.31]:60820 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932524AbXBNT4m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Feb 2007 14:56:42 -0500
Date: Wed, 14 Feb 2007 14:55:46 -0500
From: Dave Jones <davej@redhat.com>
To: Marcelo Tosatti <marcelo@kvack.org>
Cc: Jordan Crouse <jordan.crouse@amd.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] use movntq version of fast_clear_page/fast_copy_page on Geode
Message-ID: <20070214195546.GA2005@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Marcelo Tosatti <marcelo@kvack.org>,
	Jordan Crouse <jordan.crouse@amd.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org
References: <20070214190839.GA4864@dmt.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070214190839.GA4864@dmt.lan>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 14, 2007 at 05:08:39PM -0200, Marcelo Tosatti wrote:
 > 
 > movntq instruction is supported by Geode CPU's, so use
 > fast_clear_page/fast_copy_page versions that have it.

it's supported, but is it a win ?
The same was also true of the VIA C3/C7's, but due to
poor memory bandwidth, it turned out to be slower in most cases.

		Dave

-- 
http://www.codemonkey.org.uk
