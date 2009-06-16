Return-Path: <linux-kernel-owner+w=401wt.eu-S1756752AbZFPJpo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756752AbZFPJpo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 05:45:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751831AbZFPJph
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 05:45:37 -0400
Received: from h5.dl5rb.org.uk ([81.2.74.5]:60848 "EHLO h5.dl5rb.org.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751438AbZFPJpg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 05:45:36 -0400
Date: Tue, 16 Jun 2009 10:31:34 +0100
From: Ralf Baechle <ralf@linux-mips.org>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, linux-mips@linux-mips.org
Subject: Re: [PATCH 54/64] mips: remove driver_data direct access of struct
	device
Message-ID: <20090616093134.GA28585@linux-mips.org>
References: <20090616051351.GA23627@kroah.com> <1245131213-24168-54-git-send-email-gregkh@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1245131213-24168-54-git-send-email-gregkh@suse.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 15, 2009 at 10:46:43PM -0700, Greg Kroah-Hartman wrote:

> In the near future, the driver core is going to not allow direct access
> to the driver_data pointer in struct device.  Instead, the functions
> dev_get_drvdata() and dev_set_drvdata() should be used.  These functions
> have been around since the beginning, so are backwards compatible with
> all older kernel versions.
> 
> Cc: linux-mips@linux-mips.org
> Cc: Ralf Baechle <ralf@linux-mips.org>
> Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

Thanks, applied.

  Ralf
