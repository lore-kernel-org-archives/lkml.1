Return-Path: <linux-kernel-owner+w=401wt.eu-S1752144AbYIBMn2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752144AbYIBMn2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2008 08:43:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751211AbYIBMnV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Sep 2008 08:43:21 -0400
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:45301 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751121AbYIBMnU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2008 08:43:20 -0400
X-Sasl-enc: +ZEYf0MBWzi+k7Ed0oUpp019miTowflMoDVFi1Ubm7nW 1220359398
Date: Tue, 2 Sep 2008 09:43:13 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Daniel Barkalow <barkalow@iabervon.org>, linux-kernel@vger.kernel.org,
       Christopher Desjardins <cddesjardins@gmail.com>,
       Dmitry Torokhov <dtor@mail.ru>
Subject: Re: Lenovo 3000 N100 i8042 problems
Message-ID: <20080902124313.GA24358@khazad-dum.debian.net>
References: <alpine.LNX.1.00.0808240148580.19665@iabervon.org> <Pine.LNX.4.64.0809020120130.29111@twin.jikos.cz> <alpine.LNX.1.00.0809012014280.19665@iabervon.org> <alpine.LNX.1.10.0809021121410.23448@jikos.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.1.10.0809021121410.23448@jikos.suse.cz>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
	1CDB 0FE3
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 02 Sep 2008, Jiri Kosina wrote:
> so the product name both of System and Base Board are different, and 
> apparently the systems differ. Dmitry, what fields would you propose to be 
> put in the DMI matching here? I will do the patch then.

Are you sure you shouldn't be looking at BIOS version, instead? I don't know
how the Lenovo N100 series is, but chances are their i8042 is emulated
inside the ACPI EC, i.e. a firmware upgrade can change the i8042 behaviour.

I'd check BIOS versions, and ask people to upgrade to the latest, to see if
the problem goes away (or changes).  Then you will know for sure the best
approach.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
