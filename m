Return-Path: <linux-kernel-owner+w=401wt.eu-S932770AbZHZMTW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932770AbZHZMTW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 08:19:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932727AbZHZMTW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 08:19:22 -0400
Received: from hp3.statik.tu-cottbus.de ([141.43.120.68]:38753 "EHLO
	hp3.statik.tu-cottbus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932574AbZHZMTE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 08:19:04 -0400
Message-ID: <4A95282A.3020209@s5r6.in-berlin.de>
Date: Wed, 26 Aug 2009 14:18:50 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; en-US; rv:1.8.1.22) Gecko/20090605 SeaMonkey/1.1.17
MIME-Version: 1.0
To: Jeff Shanab <jshanab@earthlink.net>
CC: Rik van Riel <riel@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: Starting a grad project that may change kernel VFS. Early 	research
 Re: Starting a grad project that may change kernel VFS. Early 	research
References: <4A93428A.4070903@earthlink.net> <4A941F56.8060502@redhat.com> <4A9427C7.8020009@earthlink.net>
In-Reply-To: <4A9427C7.8020009@earthlink.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Shanab wrote:
> Rik van Riel wrote:
>> Hard links have been done like this in pretty much every
>> Unix filesystem since the 1970's.
[...]
> There is no real way to handle this becasue the two files look the same
> to the filesystem.

See above; it has been state of the art since the 70's.  With hardlinks
or symlinks, a graph which represents the FS happens to contain loops.
No rocket science involved.

[...]
> How would I display this information usefully to the user.

Certain file managers display the overall size and the size on disk.
The latter differs from the former due to
  - on-disk format overhead,
  - on-disk compression,
  - hardlinks and symlinks.
If the user copies the directory to another filesystem, the size on disk
will generally change.
-- 
Stefan Richter
-=====-==--= =--- ==-=-
http://arcgraph.de/sr/
