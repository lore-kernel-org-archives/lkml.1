Return-Path: <linux-kernel-owner+w=401wt.eu-S1755173AbYEQM3q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755173AbYEQM3q (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 May 2008 08:29:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753416AbYEQM3h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 May 2008 08:29:37 -0400
Received: from web52903.mail.re2.yahoo.com ([206.190.49.13]:31440 "HELO
	web52903.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753261AbYEQM3g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 May 2008 08:29:36 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=RbwLLBLGdgKoKcMkVaBuAWopvWhfvTiCKYE2hPgpmRrnL+t5CeamnCtf0gz6RlsDBodL4idVVoGjuTwRS1EUkKuh+48oqKeJNeiMlzq/hg064cUn1xsfmTW4g8dnCAhJVCwefRojAxFXyEEo6VheqBof0gZ2ZfGSull/SuyRhy0=;
X-YMail-OSG: yPHznPsVM1lZnRtRqtTx274F_hp1zS4KCM5ODuBA5W0FTR6h5Mvv_srbwRQg19SpRVkgWyx0uOM8BEeBZ6RtU7QkqknrluDaC.oXBaz7D_VNw1josLobuhP81w--
Date: Sat, 17 May 2008 13:29:31 +0100 (BST)
From: Chris Rankin <rankincj@yahoo.com>
Subject: Re: 2.6.25.3: serial problem (minicom)
To: Jay Cliburn <jacliburn@bellsouth.net>
Cc: linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org
In-Reply-To: <20080516123321.5674952c@osprey.hogchain.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <762763.57234.qm@web52903.mail.re2.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--- Jay Cliburn <jacliburn@bellsouth.net> wrote:
> Serial console using minicom works fine for me under 2.6.25 and
> 2.6.25.4.  Keystrokes are accepted normally.

I have just replicated this problem between two Fedora 8 boxes; minicom reads the remote serial
console fine, provided it is running on a 2.6.24.x kernel. (The serial console is from a 2.6.25.4
machine.)

My serial console is defined using the kernel parameters "console=ttyS0,115200n8", and my minicom
session as:

pr port             /dev/ttyS1
pu baudrate         115200
pu bits             8
pu parity           N
pu stopbits         1
#pu minit            ^M

Cheers,
Chris



      __________________________________________________________
Sent from Yahoo! Mail.
A Smarter Email http://uk.docs.yahoo.com/nowyoucan.html
