Return-Path: <linux-kernel-owner+w=401wt.eu-S1756122AbYDRPh2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756122AbYDRPh2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2008 11:37:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752225AbYDRPhV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Apr 2008 11:37:21 -0400
Received: from yw-out-2324.google.com ([74.125.46.31]:53099 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751484AbYDRPhU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2008 11:37:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=Nf3O6waJyFmvQ+rteCbtn+KeFzBKqSdF1ncYsfLTcsY8dCKOCzGDfyAnZezAWLieR6g4laOzlbXo6AOGztuQlmBJvp+OnfRcv41uV6Q4qfiR7OAwKQyqWFSHLxoIM0dHWgqSHAQI7XhxXezJrQqGwuQcRqOMfJQdgjFW5nHFOI4=
Message-ID: <e85b9d30804180837y39c52e26i588e4b67c87a5e9d@mail.gmail.com>
Date: Fri, 18 Apr 2008 17:37:19 +0200
From: Matthew <jackdachef@gmail.com>
To: torvalds@linux-foundation.org
Subject: Linux 2.6.25
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi everyone, hi Linus,

congratulations on this new great kernel-release :)

I've another "regression" to report for 2.6.25:

it's concerning much higher temperatures being read out by the
"coretemp" kernel-module in comparison to 2.6.24* series

e.g. where temperatures were around 40-47°C they are now constantly
jumping around 55-70°C (even in idle !)

several other users/testers have reported this issue too (both on
zen-sources [heavy patched] & latest gentoo-sources) [slightly
patched]:

http://forums.gentoo.org/viewtopic-t-684812-highlight-.html

if I understood git right it (also) happens in conjunction with an 3
weeks old acpi-snapshot
(http://repo.or.cz/w/linux-2.6/zen-sources.git?a=heads) integrated in
zen-sources

I can "reproduce" this on an Intel Core 2 Duo 6600 (Conroe) with a P5W
DH Deluxe mainboard (by Asus) since at least 2.6.25-rc8 (or possibly
also rc7)

the temperatures on mobile core (2) duo intel processors [e.g. an
T7500] seem to be read out correctly - I can't tell it exactly but
this seems to be an entirely "cosmetical" issue
(hopefully it's not the opposite and the values are now read out
correctly since such high temps would be very worrying ;) )

Keep up the great work & please don't forget your growing amount of
linux-desktop users :)

Regards

Mat
