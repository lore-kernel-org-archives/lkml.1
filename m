Return-Path: <linux-kernel-owner+w=401wt.eu-S1756987AbYGWAXY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756987AbYGWAXY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 20:23:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756751AbYGWAXK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 20:23:10 -0400
Received: from outbound-mail-144.bluehost.com ([67.222.38.34]:43428 "HELO
	outbound-mail-144.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756733AbYGWAXJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 20:23:09 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id:X-Identified-User;
	b=j2TSysqkisDy54JU6vXcMw43rpY3kFcRzIvcRvbDoRPNRVHYWVLzxtgoRU0Ap1UidHH8Hvf9TC3OYKCm2Fk0k7Wx4AtH+ZE4DlLDRh7L9nbeNm08lIuh2crc4cSD5XTF;
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Jack Howarth <howarth@bromo.msbb.uc.edu>
Subject: Re: [PATCH] x86,pci: dmi check for mackpro 2.2 mmconf
Date: Tue, 22 Jul 2008 17:23:04 -0700
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org
References: <20080722233722.GA12247@bromo.msbb.uc.edu>
In-Reply-To: <20080722233722.GA12247@bromo.msbb.uc.edu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807221723.04654.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, July 22, 2008 4:37 pm Jack Howarth wrote:
> Jesse,
>     I am unclear on what you want to push. Are you referring
> to the mmconf_end_bus_num_detect.patch and
> mmconf_end_bus_num_detect_fix.patch fixes that are already in -tip? These
> work fine in allowing MMCONFIG to work on my MacBook Pro and should go into
> the stable kernel. If you are talking about blacklisting pcie pre1.1
> devices to solve the problems with ASPM, I really don't understand how I do
> that (in terms of finding out what devices to blacklist).

I was referring to the ASPM patch.  You reported that you needed to disable 
ASPM in order to boot without hanging, right?  I just wanted to make sure 
that Shaohua's patch allowed you to do that with ASPM=y.

Thanks,
Jesse
