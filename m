Return-Path: <linux-kernel-owner+w=401wt.eu-S1762965AbYGOUc1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762965AbYGOUc1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 16:32:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755879AbYGOUcR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 16:32:17 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46953 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755345AbYGOUcQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 16:32:16 -0400
Date: Tue, 15 Jul 2008 13:30:57 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Marcel Holtmann <marcel@holtmann.org>
cc: David Woodhouse <dwmw2@infradead.org>, Frans Pop <elendil@planet.nl>,
       jeff@garzik.org, arjan@infradead.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, linux-kernel@vger.kernel.org
Subject: Re: [GIT *] Allow request_firmware() to be satisfied from in-kernel,
 use it in more drivers.
In-Reply-To: <1216153270.27242.110.camel@violet.holtmann.net>
Message-ID: <alpine.LFD.1.10.0807151329361.2867@woody.linux-foundation.org>
References: <1216077806.27455.85.camel@shinybook.infradead.org>  <20080714164119.99c33d5b.akpm@linux-foundation.org>  <20080714165956.7fe2d4ee@infradead.org> <487C0365.5030203@garzik.org>  <487C0365.5030203@garzik.org>  <alpine.LFD.1.10.0807141911270.3017@woody.linux-foundation.org>
  <200807151757.10626.elendil@planet.nl>  <1216149637.27242.65.camel@violet.holtmann.net>  <alpine.LFD.1.10.0807151223290.3351@woody.linux-foundation.org>  <1216150616.27455.377.camel@shinybook.infradead.org>  <alpine.LFD.1.10.0807151244320.3351@woody.linux-foundation.org>
  <1216151640.27242.90.camel@violet.holtmann.net>  <alpine.LFD.1.10.0807151301130.2867@woody.linux-foundation.org> <1216153270.27242.110.camel@violet.holtmann.net>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 15 Jul 2008, Marcel Holtmann wrote:
> 
> so request_firmware() is well established and works. It is used by a
> bunch of drivers at the moment.

That's not the question.

The question is whether it works with the *new* users.

Which it would apparently NOT do for everybody if we put the new drivers 
in any other place than /lib/firmware, very much including a kernel- 
specific subdirectory there.

		Linus
