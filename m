Return-Path: <linux-kernel-owner+w=401wt.eu-S1756889AbZCJRLT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756889AbZCJRLT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 13:11:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755447AbZCJRLC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 13:11:02 -0400
Received: from kroah.org ([198.145.64.141]:33026 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754311AbZCJRLA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 13:11:00 -0400
Date: Tue, 10 Mar 2009 10:08:02 -0700
From: Greg KH <greg@kroah.com>
To: Scott James Remnant <scott@canonical.com>
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: [PATCH 26/31] usb: Auto-load cdc_acm module when device opened.
Message-ID: <20090310170802.GA4923@kroah.com>
References: <cover.1236702228.git.scott@canonical.com> <c9944f91c6740450d11cb26c4e8e19e2cb612abe.1236702228.git.scott@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c9944f91c6740450d11cb26c4e8e19e2cb612abe.1236702228.git.scott@canonical.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 02, 2009 at 06:46:15PM +0000, Scott James Remnant wrote:
> The cdc_acm module is missing the char-major-166-* alias that would
> cause it to be auto-loaded when a device of that type is opened.  This
> patch adds the alias.

You really have users that are using a static /dev that need this kind
of fix?  I thought we were phasing out the char-major- aliases as they
don't make any sense anymore.

thanks,

greg k-h
