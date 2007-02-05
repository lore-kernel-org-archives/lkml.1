Return-Path: <linux-kernel-owner+w=401wt.eu-S1751432AbXBEKtp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751432AbXBEKtp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Feb 2007 05:49:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752146AbXBEKtp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Feb 2007 05:49:45 -0500
Received: from outpost.ds9a.nl ([213.244.168.210]:43377 "EHLO outpost.ds9a.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751432AbXBEKto (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Feb 2007 05:49:44 -0500
Date: Mon, 5 Feb 2007 11:49:43 +0100
From: bert hubert <bert.hubert@netherlabs.nl>
To: Philippe Troin <phil@fifi.org>
Cc: Roland Kuhn <rkuhn@e18.physik.tu-muenchen.de>,
       Guillaume Chazarain <guichaz@gmail.com>,
       Denis Vlasenko <vda.linux@googlemail.com>, linux-kernel@vger.kernel.org
Subject: Re: O_NONBLOCK setting "leak" outside of a process??
Message-ID: <20070205104942.GA7053@outpost.ds9a.nl>
Mail-Followup-To: bert hubert <bert.hubert@netherlabs.nl>,
	Philippe Troin <phil@fifi.org>,
	Roland Kuhn <rkuhn@e18.physik.tu-muenchen.de>,
	Guillaume Chazarain <guichaz@gmail.com>,
	Denis Vlasenko <vda.linux@googlemail.com>,
	linux-kernel@vger.kernel.org
References: <200701272152.11087.vda.linux@googlemail.com> <87bqkhuqpp.fsf@tantale.fifi.org> <200702020000.40524.vda.linux@googlemail.com> <87abzxbhau.fsf@tantale.fifi.org> <E0CFA8EB-F706-49E8-A1D1-7BAF19C8D271@e18.physik.tu-muenchen.de> <3d8471ca0702020548n9455f4fre8c4ceea3f070a51@mail.gmail.com> <24DAE20A-F4CC-4A8F-902A-2A73D0DA2EB1@e18.physik.tu-muenchen.de> <87bqkc9yht.fsf@tantale.fifi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87bqkc9yht.fsf@tantale.fifi.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

O_NONBLOCK supposedly hits the entire 'ofile' and not just the fd:
http://cr.yp.to/unix/nonblock.html

-- 
http://www.PowerDNS.com      Open source, database driven DNS Software 
http://netherlabs.nl              Open and Closed source services
