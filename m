Return-Path: <linux-kernel-owner+w=401wt.eu-S1761274AbXE3WXR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761274AbXE3WXR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 18:23:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758427AbXE3WW6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 18:22:58 -0400
Received: from an-out-0708.google.com ([209.85.132.244]:50035 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758607AbXE3WW4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 18:22:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=dfx2yCeVkeeAmOVBKgJrLu76jXUEXZOaKMSCga38Spo+s06Ji5DLElzSRFK1HAbuAykkw26/gNe7nFstkBm+EaP5upE/Fe8QCXjQkf+IQmYN5pn6hJYO+BF6lzVIsHmAcnGavg1HvheSAD89k+8wIpFMc9Y4b9ChGXuxKVqQhPY=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Junio C Hamano <junkio@cox.net>
Subject: Re: [PATCH 3/3] ide_in_drive_list(): "ALL" is not a wildcard anymore.
Date: Wed, 30 May 2007 22:47:26 +0200
User-Agent: KMail/1.9.6
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Linux Kernel <linux-kernel@vger.kernel.org>, linux-ide@vger.kernel.org,
       Dave Jones <davej@redhat.com>
References: <20070521145042.GA6957@redhat.com> <200705282141.42507.bzolnier@gmail.com> <7vsl9g7dd8.fsf@assigned-by-dhcp.cox.net>
In-Reply-To: <7vsl9g7dd8.fsf@assigned-by-dhcp.cox.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705302247.26891.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 29 May 2007, Junio C Hamano wrote:
> This removes the support to treat "ALL" as a wildcard for
> firmware revision.  This is made a separate patch, as it will
> break out-of-tree ide drivers that feed its own table that uses
> "ALL" as the wildcard to ide_in_drive_list().
> 
> Signed-off-by: Junio C Hamano <junkio@cox.net>

applied
