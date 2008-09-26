Return-Path: <linux-kernel-owner+w=401wt.eu-S1755242AbYIZLIb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755242AbYIZLIb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2008 07:08:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752819AbYIZLIU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Sep 2008 07:08:20 -0400
Received: from emulex.emulex.com ([138.239.112.1]:54773 "EHLO
	emulex.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751635AbYIZLIT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2008 07:08:19 -0400
Message-ID: <48DCC284.3040408@emulex.com>
Date: Fri, 26 Sep 2008 07:07:48 -0400
From: James Smart <James.Smart@Emulex.Com>
User-Agent: Thunderbird 2.0.0.16 (Windows/20080708)
MIME-Version: 1.0
To: Jing Huang <huangj@Brocade.COM>
CC: James Bottomley <James.Bottomley@HansenPartnership.com>,
       Greg KH <greg@kroah.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
       Ramkumar Vadivelu <rvadivel@Brocade.COM>,
       "Srikanth Rayas (CW)" <srayas@Brocade.COM>,
       Vinodh Ravindran <vravindr@Brocade.COM>
Subject: Re: [PATCH 5/6] bfa: Brocade BFA FC SCSI driver submission (2ndtry)
References: <200809260106.m8Q160kj028501@swe37.brocade.com> <20080926025514.GD9480@kroah.com> <4C94DE2070B172459E4F1EE14BD2364E01F28079@HQ-EXCH-5.corp.brocade.com> <1222408937.3265.17.camel@localhost.localdomain> <4C94DE2070B172459E4F1EE14BD2364E01F280A3@HQ-EXCH-5.corp.brocade.com>
In-Reply-To: <4C94DE2070B172459E4F1EE14BD2364E01F280A3@HQ-EXCH-5.corp.brocade.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 26 Sep 2008 11:07:56.0266 (UTC) FILETIME=[20E664A0:01C91FC8]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We are finally finishing up CT/ELS passthru in the FC transport; SCSI 
passthru exists, but via the scsi_generic driver (so it's not part of 
the transport or LLDD); and async event notification is already present 
in the fc transport.

-- james s

Jing Huang wrote:
> Hi James,
> 
> It is encouraging to know that we can discuss and add new feature into
> existing fc transport. I guess this is opensource all about. I didn't
> have linux opensource experience before, so I was not quite sure how
> easy to request new features in fc transport such as mechanism to create
> multiple subdirectories for different level of statistics info in
> addition to the snia fc statitistics we already have, and other features
> such as CT/SCSI passthru and asynchronous event notification etc.
> 
> Thanks
> 
> Jing
