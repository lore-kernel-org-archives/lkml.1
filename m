Return-Path: <linux-kernel-owner+w=401wt.eu-S1753491AbYCYJw3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753491AbYCYJw3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2008 05:52:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751720AbYCYJwV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Mar 2008 05:52:21 -0400
Received: from smtp-out003.kontent.com ([81.88.40.217]:43559 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751507AbYCYJwU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2008 05:52:20 -0400
From: Oliver Neukum <oliver@neukum.org>
Organization: Novell
To: linux-pm@lists.linux-foundation.org
Subject: Re: [linux-pm] [RFC][PATCH] PM: Introduce new top level =?utf-8?q?suspend=09and_hibernation_callbacks?= (rev. 2)
Date: Tue, 25 Mar 2008 10:49:24 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Johannes Berg <johannes@sipsolutions.net>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Alexey Starikovskiy <astarikovskiy@suse.de>,
       LKML <linux-kernel@vger.kernel.org>
References: <200803210101.04706.rjw@sisk.pl> <1206058863.16475.165.camel@johannes.berg>
In-Reply-To: <1206058863.16475.165.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200803251049.27696.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Freitag, 21. März 2008 01:21:03 schrieb Johannes Berg:
> > + * All of the above callbacks, except for @complete(), return error codes.
> > + * However, the error codes returned by the resume operations, @resume(),
> > + * @thaw(), and @restore(), are only printed in the system logs, since the PM
> > + * core cannot do anything else about them.
> 
> Why bother and not just make them return void, the error printing can
> most likely be done much much better in the callback since that possibly
> has information on why it failed.

A device that cannot wake up is unusable. Shouldn't the pm core disconnect()
such a device?

	Regards
		Oliver

