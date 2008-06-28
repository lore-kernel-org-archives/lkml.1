Return-Path: <linux-kernel-owner+w=401wt.eu-S1753983AbYF1EZb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753983AbYF1EZb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jun 2008 00:25:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751533AbYF1EZU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Jun 2008 00:25:20 -0400
Received: from mta23.gyao.ne.jp ([125.63.38.249]:45312 "EHLO mx.gate01.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751430AbYF1EZS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jun 2008 00:25:18 -0400
Date: Sat, 28 Jun 2008 13:22:40 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Johannes Weiner <hannes@saeurebad.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org
Subject: Re: [PATCH 02/20] mm: generic show_mem()
Message-ID: <20080628042240.GB25492@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Johannes Weiner <hannes@saeurebad.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
References: <20080627115349.743368154@saeurebad.de> <20080627120048.059732179@saeurebad.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080627120048.059732179@saeurebad.de>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 27, 2008 at 01:53:51PM +0200, Johannes Weiner wrote:
> This implements a platform-independent version of show_mem().
> 
> Signed-off-by: Johannes Weiner <hannes@saeurebad.de>

Looking at this again, does having this as a Kconfig option really make
sense? We have no tristate in-tree users of this that I can see, wouldn't
this be better off in lib/? It would be preferable not to let the
HAVE_foo stuff get out of hand if we can avoid it.
