Return-Path: <linux-kernel-owner+w=401wt.eu-S1756123AbZJGXPK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756123AbZJGXPK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 19:15:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755954AbZJGXPJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 19:15:09 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:52609 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755785AbZJGXPI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 19:15:08 -0400
Date: Thu, 8 Oct 2009 00:15:54 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Jack Byer <ojbyer@usa.net>
Cc: linux-kernel@vger.kernel.org
Subject: Re: iso9660 mount problem
Message-ID: <20091008001554.0ed1212c@lxorguk.ukuu.org.uk>
In-Reply-To: <haj471$fn8$1@ger.gmane.org>
References: <haj471$fn8$1@ger.gmane.org>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 07 Oct 2009 17:22:02 -0500
Jack Byer <ojbyer@usa.net> wrote:

> I have a CD of a commercial software program that I am attempting to run 
> under wine. The CD works without problems under Windows, but when I mount  
> it on linux the file system appears to be empty (no files or 
> directories). The drive is capable of reading the CD because "strings 
> /dev/cdrom" works.
> 
> What would I need to do in order to troubleshoot this problem?

Firstly check what occurs if you mount it by hand with -t iso9660 and
with -t udf. Secondly check dmesg for any diagnostics from the mount such
as corrupt metadata on the CD.
