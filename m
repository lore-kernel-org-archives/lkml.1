Return-Path: <linux-kernel-owner+w=401wt.eu-S1757231AbYDULym@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757231AbYDULym (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 07:54:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755487AbYDULyd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 07:54:33 -0400
Received: from wa-out-1112.google.com ([209.85.146.179]:27062 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755391AbYDULyc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 07:54:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=stq5e/PPkFAlL71k1Tkly6oMvhqNxGLogTU0uvkqve6r9e9eTKGqSiuxQcPG5r0Cpcc4ZntMqYZq3qQvK3FDbLtdxqFtguy6fLaYB/qHPflTt7YhCW61RNRtFYYOdkG9LLQy4v0BK0YLoprANRtJy0Zl8sL+aBU/SLdQwTzaseQ=
Message-ID: <6041d2000804210454t4c83de95td9bfd85c98de80b6@mail.gmail.com>
Date: Mon, 21 Apr 2008 07:54:29 -0400
From: "Marc Dionne" <marc.c.dionne@gmail.com>
To: g3vbv@blueyonder.co.uk
Subject: Re: 2.6.25-git1/2 not seeing /dev/sda1 (XFS root) or /dev/sda2 (swap) partitions on a SATA drive
Cc: "Alexey Dobriyan" <adobriyan@gmail.com>, linux-kernel@vger.kernel.org
In-Reply-To: <480B3958.9010708@blueyonder.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <480A9C1E.8050505@blueyonder.co.uk>
	 <20080420112549.GB4902@martell.zuzino.mipt.ru>
	 <480B3958.9010708@blueyonder.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 20, 2008 at 8:38 AM, Sid Boyce <g3vbv@blueyonder.co.uk> wrote:
> > > 2.6.25 x86_64 boots fine as does -git1/2 boxes using reiserfs and ext3.
> > > With xfs it can't find these and drops into a shell.
> > > /dev/disk/by-id/scsi-SATA_WDC_WD5000AAKS-_WD-WCAS85018679-part2 swap
> > >      swap       defaults              0 0
> > > /dev/disk/by-id/scsi-SATA_WDC_WD5000AAKS-_WD-WCAS85018679-part1 /
> > >   xfs        defaults              1 1
> > >
> > > 00:0c.0 IDE interface: nVidia Corporation MCP55 IDE (rev a1)
> > > 00:0d.0 IDE interface: nVidia Corporation MCP55 SATA Controller (rev a2)
> > > 00:0d.1 IDE interface: nVidia Corporation MCP55 SATA Controller (rev a2)
> > > 00:0d.2 IDE interface: nVidia Corporation MCP55 SATA Controller (rev a2)
> > > 03:00.0 Mass storage controller: Silicon Image, Inc. SiI 3132 Serial ATA
> > > Raid II Controller (rev 01)

Perhaps related to these threads ?
    http://marc.info/?l=linux-ide&m=120866699221716
    http://marc.info/?l=linux-scsi&m=120854308421912

Marc
