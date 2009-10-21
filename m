Return-Path: <linux-kernel-owner+w=401wt.eu-S1753040AbZJUCae@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753040AbZJUCae (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Oct 2009 22:30:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752927AbZJUCad
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Oct 2009 22:30:33 -0400
Received: from tx2ehsobe001.messaging.microsoft.com ([65.55.88.11]:51723 "EHLO
	TX2EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752852AbZJUCab (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Oct 2009 22:30:31 -0400
X-SpamScore: -5
X-BigFish: VPS-5(zz98dNzz1202hzzz32i6bh61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0KRUEYP-02-2R4-02
X-M-MSG: 
Date: Wed, 21 Oct 2009 10:30:16 +0800
From: Crane Cai <crane.cai@amd.com>
To: "Darrick J. Wong" <djwong@us.ibm.com>
CC: lenb@kernel.org, linux-kernel <linux-kernel@vger.kernel.org>,
       linux-i2c@vger.kernel.org, linux-acpi@vger.kernel.org
Subject: Re: [PATCH] i2c-scmi: Quirk to work on IBM machines with broken
	BIOSes
Message-ID: <20091021023016.GC32413@crane-desktop>
Mail-Followup-To: Crane Cai <crane.cai@amd.com>,
	"Darrick J. Wong" <djwong@us.ibm.com>, lenb@kernel.org,
	linux-kernel <linux-kernel@vger.kernel.org>,
	linux-i2c@vger.kernel.org, linux-acpi@vger.kernel.org
References: <20091020231149.GM26149@tux1.beaverton.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <20091020231149.GM26149@tux1.beaverton.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-OriginalArrivalTime: 21 Oct 2009 02:30:16.0387 (UTC) FILETIME=[6CDF7930:01CA51F6]
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Darrick,

On Tue, Oct 20, 2009 at 04:11:49PM -0700, Darrick J. Wong wrote:
> On some old IBM workstations and desktop computers, the BIOS presents in the
> DSDT an SMBus object that is missing the HID identifier that the i2c-scmi
> driver looks for.  It also omits the leading "_" in the method names (it should
> be _SBR, not SBR_).  Modify the ACPI device scan code to insert the missing HID
> if it finds an IBM system with such an object, and modify the i2c-scmi driver
> to handle the odd method names.
I have a suggestion:
You can need not to add quirk in acpi part, instead you can add your ACPI device
HID in i2c-scmi with your specificied methods set.

-- 
Best Regards,
- Crane

