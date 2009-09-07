Return-Path: <linux-kernel-owner+w=401wt.eu-S1754080AbZIGR2H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754080AbZIGR2H (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Sep 2009 13:28:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753472AbZIGR2G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Sep 2009 13:28:06 -0400
Received: from rcsinet12.oracle.com ([148.87.113.124]:48518 "EHLO
	rgminet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752249AbZIGR2E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Sep 2009 13:28:04 -0400
Date: Mon, 7 Sep 2009 10:27:47 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>, linux-scsi@vger.kernel.org
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: Re: linux-next: Tree for September 7 (scsi/qla2x)
Message-Id: <20090907102747.ac6b98ff.randy.dunlap@oracle.com>
In-Reply-To: <20090907210206.7830ba68.sfr@canb.auug.org.au>
References: <20090907210206.7830ba68.sfr@canb.auug.org.au>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: abhmt002.oracle.com [141.146.116.11]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090205.4AA54296.001C:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 7 Sep 2009 21:02:06 +1000 Stephen Rothwell wrote:

> Hi all,
> 
> Changes since 20090904:


when CONFIG_MODULES=n:

drivers/scsi/qla2xxx/qla_os.c:2685: error: dereferencing pointer to incomplete type

in
	kobject_uevent_env(&(&vha->hw->pdev->driver->driver)->owner->mkobj.kobj,
	    KOBJ_CHANGE, envp);

---
~Randy
LPC 2009, Sept. 23-25, Portland, Oregon
http://linuxplumbersconf.org/2009/
