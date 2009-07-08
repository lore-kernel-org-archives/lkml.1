Return-Path: <linux-kernel-owner+w=401wt.eu-S1757941AbZGHRxX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757941AbZGHRxX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jul 2009 13:53:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756005AbZGHRxP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Jul 2009 13:53:15 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:59498 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755789AbZGHRxP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jul 2009 13:53:15 -0400
Message-ID: <4A54DD14.8050100@vlnb.net>
Date: Wed, 08 Jul 2009 21:53:24 +0400
From: Vladislav Bolkhovitin <vst@vlnb.net>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
       scst-devel <scst-devel@lists.sourceforge.net>
CC: James Smart <James.Smart@Emulex.Com>
Subject: [ANNOUNCE]: SCST Target driver support for Emulex lpfc FC/FCoE adapters
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V01U2FsdGVkX18AA490+12nb+AahXLdTnAS6jMw+kCSgg6HL1j
 pzHOTgy219+UkiekhatelvoYckKOZQEwFpiXwPeY3ZNea+PP63
 pJvWgTV5kspLJXo8OoYqg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,

I'm glad to announce that SCST target driver support for Emulex lpfc 
FC/FCoE adapters has been created and linked to the SCST project. Thanks 
to the Emulex team for putting this together.

The driver allows for lpfc adapters to be placed in initiator and/or 
target mode. Those in initiator mode will continue to function with the 
SCSI subsystem as usual. A lpfc_scst helper module is then loaded that 
binds that target mode adapters with the SCST subsystem for use as FCP 
targets. NPIV is also supported, allowing virtual ports to be created 
with individual SCST target instances bound to them.

The lpfc SCST driver kit is part of the lpfcxxxx SourceForge project 
located at https://sourceforge.net/projects/lpfcxxxx. You can find its 
README and HOWTO in http://lpfcxxxx.sourceforge.net/README and 
http://lpfcxxxx.sourceforge.net/HOWTO.lpfc correspondingly.

SCST page of the Emulex lpfc target driver located at 
http://scst.sourceforge.net/target_emulex.html.

Vlad
