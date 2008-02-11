Return-Path: <linux-kernel-owner+w=401wt.eu-S1761126AbYBLANi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761126AbYBLANi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 19:13:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756371AbYBLAND
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 19:13:03 -0500
Received: from nf-out-0910.google.com ([64.233.182.185]:11782 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755869AbYBLANA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 19:13:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-disposition:message-id:content-type:content-transfer-encoding;
        b=hncZYYkS8GLuiKtOhKrGquG1nwo63WfmshXk1p5fuuSJEqguhjFVbqXdiAlH0UzGb1h8WCOxmEDTAhhWr7SoNfKE7aWUaEUANltA7aQmQvWAaBMOgYhCRm8zqN3Cqg6DaNkcSS9LcxhObagDMpvCH618n0D5t1j9iyGNCjh8aTs=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: petkovbb@gmail.com
Subject: Re: [PATCH 2/2] ide-tape: remove atomic test/set macros for packet commands
Date: Mon, 11 Feb 2008 23:12:57 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20071204.744707)
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
References: <1202132440-26648-1-git-send-email-petkovbb@gmail.com> <200802091725.23372.bzolnier@gmail.com> <20080209194345.GF23177@gollum.tnic>
In-Reply-To: <20080209194345.GF23177@gollum.tnic>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200802112312.57559.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 09 February 2008, Borislav Petkov wrote:
> From 92dd5c1cfb27c0945894a3a055098290047d1ff0 Mon Sep 17 00:00:00 2001
> From: Borislav Petkov <petkovbb@gmail.com>
> Date: Sat, 9 Feb 2008 20:33:48 +0100
> Subject: [PATCH 2/2] ide-tape: remove atomic test/set macros for packet commands
> 
> Removing the atomic tests for pc's is unobjectionable. Since this driver will
> probably go to /dev/null soon, the atomic tests for tape->flags are left in
> place for there are some situations where they're needed (chrdev DSC handling,
> low level pipeline operation and so on). While at it, rename all test/set flag
> bit defines explicitly to *_FLAG_* for clarity.
> 
> Signed-off-by: Borislav Petkov <petkovbb@gmail.com>

applied
