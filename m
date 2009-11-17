Return-Path: <linux-kernel-owner+w=401wt.eu-S1755356AbZKQQtm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755356AbZKQQtm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Nov 2009 11:49:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754812AbZKQQtl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Nov 2009 11:49:41 -0500
Received: from hp3.statik.tu-cottbus.de ([141.43.120.68]:36159 "EHLO
	hp3.statik.tu-cottbus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752580AbZKQQtk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Nov 2009 11:49:40 -0500
Message-ID: <4B02D410.4070004@s5r6.in-berlin.de>
Date: Tue, 17 Nov 2009 17:49:20 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; en-US; rv:1.8.1.23) Gecko/20090825 SeaMonkey/1.1.18
MIME-Version: 1.0
To: "" <jamagallon@ono.com>
CC: Linux-Kernel <linux-kernel@vger.kernel.org>
Subject: Re: Out of order kernel messages in sd detection
References: <C991F902-ED0F-44B5-8326-DB51C2E0C899@ono.com>
In-Reply-To: <C991F902-ED0F-44B5-8326-DB51C2E0C899@ono.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

J.A. Magallón wrote:
> And, BTW, would sometime the numbering in ataX be made consistent with
> SCSI ( ie, ata1 is scsi0....).

No.  There are several other transports which can register SCSI
initiator instances at any time.  SAS, USB, 1394, FC, ...

Remember:  These object numbers don't have any deeper meaning.  There is
nothing more to them than (a) that they are systemwide unique and (b)
persist (only) for the duration of the object's lifetime.

Look for persistent and possibly globally unique identifiers (serial
numbers) of the actual hardware instead.  Udev for example uses them to
create useful symlinks to device files.
-- 
Stefan Richter
-=====-==--= =-== =---=
http://arcgraph.de/sr/
