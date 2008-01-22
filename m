Return-Path: <linux-kernel-owner+w=401wt.eu-S1752631AbYAVMjl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752631AbYAVMjl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2008 07:39:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758023AbYAVMj3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jan 2008 07:39:29 -0500
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:54001 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751929AbYAVMj2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2008 07:39:28 -0500
X-Sasl-enc: 7FRH5w3+76DLVK33mN6GACQ2en8z2W4TXUM8oPHYBDcA 1201005566
Date: Tue, 22 Jan 2008 10:39:23 -0200
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Zhang Rui <rui.zhang@intel.com>, linux-kernel@vger.kernel.org,
       linux-acpi@vger.kernel.org, len.brown@intel.com
Subject: Re: [PATCH] Rationalise ACPI backlight implementation
Message-ID: <20080122123923.GC15490@khazad-dum.debian.net>
References: <20071226020325.GA21099@srcf.ucam.org> <1200990809.7424.31.camel@acpi-sony.sh.intel.com> <20080122114605.GA23983@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080122114605.GA23983@srcf.ucam.org>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
	1CDB 0FE3
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 22 Jan 2008, Matthew Garrett wrote:
> On Tue, Jan 22, 2008 at 04:33:29PM +0800, Zhang Rui wrote:
> > I have no obvious objection on either of these two proposals.
> > But one thing to mention is that
> > both of these two patches is written on the assumption that the
> > brightness levels listed in _BCL method are in ascending order, while
> > this is not stated in the ACPI spec.
> > Is this a problem?
> 
> The driver already makes that assumption, and it's implicit in the spec.

Actually, no, it is not implicit.  The spec clearly states that the
brightness values will be cycled through the ones given by that list.  It is
implicit that brightness up actions will cycle through the list in order,
and brightness down will cycle through the list in reverse order.

If a vendor where to decide to place the most used brightness values in the
beginning of the list, and the rest of it later, he would be allowed to do
so.  Nobody was weird enough to do it yet though, AFAIK.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
