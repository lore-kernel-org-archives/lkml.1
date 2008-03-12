Return-Path: <linux-kernel-owner+w=401wt.eu-S1753565AbYCLTzA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753565AbYCLTzA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2008 15:55:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751564AbYCLTyw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Mar 2008 15:54:52 -0400
Received: from fmmailgate03.web.de ([217.72.192.234]:52483 "EHLO
	fmmailgate03.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751623AbYCLTyv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2008 15:54:51 -0400
From: Chr <chunkeey@web.de>
To: Samuel Tardieu <sam@rfc1149.net>
Subject: Re: INFO: task mount:11202 blocked for more than 120 seconds
Date: Wed, 12 Mar 2008 20:53:12 +0100
User-Agent: KMail/1.9.9
Cc: device-mapper development <dm-devel@redhat.com>,
       Christian Kujau <lists@nerdbynature.de>, David Chinner <dgc@sgi.com>,
       LKML <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com
References: <alpine.DEB.1.00.0803072116420.7723@sheep.housecafe.de> <20080309213441.GQ155407@sgi.com> <2008-03-12-19-03-51+trackit+sam@rfc1149.net>
In-Reply-To: <2008-03-12-19-03-51+trackit+sam@rfc1149.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803122053.13265.chunkeey@web.de>
X-Provags-ID: V01U2FsdGVkX1/TTeeWfOjyNlSRcwjuX/CPw1hC24xQ2J3yJDI0
	TTxGbbCKTcl3REXf5L5gunwauzJOHrEBAlhsFZ4ridXrkjaW2c
	JyhtH8Iyc=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 12 March 2008 19:03:51 Samuel Tardieu wrote:
>
> David> Oh, dm-crypt. Well, I'd definitely start looking there. XFS has
> David> a history of exposing dm-crypt bugs, and these hangs appear to
> David> be I/O congestion/scheduling related and not XFS. Also, we
> David> haven't changed anything related to plug/unplug of block
> David> devices in XFS recently, so that also points to some other
> David> change as well...
>
me too... 

http://lkml.org/lkml/2008/3/11/377
(BTW: I'm still bisecting it... can somebody please confirm that 2.6.24-git17 
http://www.kernel.org/pub/linux/kernel/v2.6/snapshots/patch-2.6.24-git17.bz2
was the _last_ "good" one?)  

BTW:
by pressing "SYSRQ-S (Emerg. Sync)" over and over again can unlock
some but not all "D" tasks... 

Regards,
	Chr.

