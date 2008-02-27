Return-Path: <linux-kernel-owner+w=401wt.eu-S1758759AbYB0UXT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758759AbYB0UXT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2008 15:23:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756339AbYB0UXJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Feb 2008 15:23:09 -0500
Received: from mx1.redhat.com ([66.187.233.31]:39930 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756267AbYB0UXI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2008 15:23:08 -0500
From: Jarod Wilson <jwilson@redhat.com>
Organization: Red Hat, Inc.
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: [PATCH 1/2] firewire: endianess fix
Date: Wed, 27 Feb 2008 15:21:04 -0500
User-Agent: KMail/1.9.6 (enterprise 0.20071204.744707)
Cc: linux1394-devel@lists.sourceforge.net,
       Harvey Harrison <harvey.harrison@gmail.com>,
       Sam Ravnborg <sam@ravnborg.org>, linux-kernel@vger.kernel.org,
       sparclinux@vger.kernel.org, linuxppc-dev@ozlabs.org,
       Kristian Hoegsberg <krh@bitplanet.net>
References: <20080220220326.GA22328@uranus.ravnborg.org> <200802271458.28401.jwilson@redhat.com> <47C5C340.7080302@s5r6.in-berlin.de>
In-Reply-To: <47C5C340.7080302@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802271521.05099.jwilson@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 27 February 2008 03:08:32 pm Stefan Richter wrote:
> Jarod Wilson wrote:
> > Works just fine with the Apple UniNorth controller in my powerbook in
> > cursory testing.
>
> Could you remove the OHCI1394_HCControl_postedWriteEnable flag from
> fw-ohci.c::ohci_enable() and test without and with the endianess patch?

Sure, added to the todo list along with making sure things survive bus resets.

-- 
Jarod Wilson
jwilson@redhat.com
