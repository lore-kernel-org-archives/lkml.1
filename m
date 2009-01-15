Return-Path: <linux-kernel-owner+w=401wt.eu-S1757937AbZAOMEo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757937AbZAOMEo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 07:04:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753895AbZAOMEe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 07:04:34 -0500
Received: from slimlogic.co.uk ([89.16.172.20]:39679 "EHLO slimlogic.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753710AbZAOMEd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 07:04:33 -0500
Subject: Re: [patch 2.6.29-rc] regulator: add get_status()
From: Liam Girdwood <lrg@slimlogic.co.uk>
To: David Brownell <david-b@pacbell.net>
Cc: Mark Brown <broonie@sirena.org.uk>, lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <200901142303.17906.david-b@pacbell.net>
References: <200811091531.46003.david-b@pacbell.net>
	 <200811161458.17212.david-b@pacbell.net>
	 <20081117015127.GA10883@sirena.org.uk>
	 <200901142303.17906.david-b@pacbell.net>
Content-Type: text/plain
Date: Thu, 15 Jan 2009 12:04:30 +0000
Message-Id: <1232021071.4934.366.camel@vega.slimlogic.co.uk>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-01-14 at 23:03 -0800, David Brownell wrote:
> From: David Brownell <dbrownell@users.sourceforge.net>
> 
> Based on previous LKML discussions:
> 
>  * Update docs for regulator sysfs class attributes to highlight
>    the fact that all current attributes are intended to be control
>    inputs, including notably "state" and "opmode" which previously
>    implied otherwise.
> 
>  * Define a new regulator driver get_status() method, which is the
>    first method reporting regulator outputs instead of inputs.
>    It can report on/off and error status; or instead of simply
>    "on", report the actual operating mode.
> 
> For the moment, this is a sysfs-only interface, not accessible to 
> regulator clients.  Such clients can use the current notification
> interfaces to detect errors, if the regulator reports them.
> 
> Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
> ---

Applied.

Thanks

Liam


