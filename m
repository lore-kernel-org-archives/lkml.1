Return-Path: <linux-kernel-owner+w=401wt.eu-S1758928AbYHFTTJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758928AbYHFTTJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 15:19:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755681AbYHFTS4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 15:18:56 -0400
Received: from 41-052.adsl.zetnet.co.uk ([194.247.41.52]:39904 "EHLO
	mail.esperi.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754588AbYHFTS4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 15:18:56 -0400
To: linux-kernel@vger.kernel.org
Subject: Re: writable packet CD mounting and non-root formatting in 2.6.26.x?
References: <87ej52vtxq.fsf@hades.wkstn.nix>
From: Nix <nix@esperi.org.uk>
Emacs: the answer to the world surplus of CPU cycles.
Date: Wed, 06 Aug 2008 20:18:52 +0100
In-Reply-To: <87ej52vtxq.fsf@hades.wkstn.nix> (nix@esperi.org.uk's message of "6 Aug 2008 20:13:41 +0100")
Message-ID: <87abfqvtnn.fsf@hades.wkstn.nix>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) XEmacs/21.5-b28 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-DCC--Metrics: hades 1114; Body=1 Fuz1=1 Fuz2=1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6 Aug 2008, nix@esperi.org.uk told this:

> It seems to be impossible to mount packet-written CD-RWs writably in
> 2.6.26.x, even as root. Things worked in 2.6.25.x.

Formatting them as non-root (with cdrwtool 1.0.0b3) seems broken too:

nix@hades 129 /home/nix% cdrwtool -d /dev/cdrw -q < /dev/null
using device /dev/cdrw
7294KB internal buffer
setting write speed to 4x
wait_cmd: Bad address
Command failed: bb 00 ff ff 02 c0 00 00 00 00 00 00 - sense 00.00.00
set speed
can't unlock door

It seems to work as root (well, it's got further but the lengthy
formatting process is still continuing).
