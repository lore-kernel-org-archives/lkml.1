Return-Path: <linux-kernel-owner+w=401wt.eu-S1752767AbYJTRAm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752767AbYJTRAm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2008 13:00:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753779AbYJTQ7p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Oct 2008 12:59:45 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:35224 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753767AbYJTQ7o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2008 12:59:44 -0400
Date: Mon, 20 Oct 2008 11:59:38 -0500
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Andrey Mirkin <major@openvz.org>
Cc: containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       Pavel Emelyanov <xemul@openvz.org>
Subject: Re: [PATCH 02/10] Make checkpoint/restart functionality modular
Message-ID: <20081020165938.GB25885@us.ibm.com>
References: <1224285098-573-1-git-send-email-major@openvz.org> <1224285098-573-2-git-send-email-major@openvz.org> <1224285098-573-3-git-send-email-major@openvz.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1224285098-573-3-git-send-email-major@openvz.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Andrey Mirkin (major@openvz.org):
> A config option CONFIG_CHECKPOINT is introduced.
> New structure cpt_operations is introduced to store pointers to
> checkpoint/restart functions from module.

I thought we had decided not to use a kernel module?

Louis' comments on your patch 8 regarding module pinning suggests that
details about using a module will detract from proper review of the core
c/r functionality...

-serge
