Return-Path: <linux-kernel-owner+w=401wt.eu-S1757579AbYEON2I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757579AbYEON2I (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2008 09:28:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751842AbYEON15
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 May 2008 09:27:57 -0400
Received: from smtp-out003.kontent.com ([81.88.40.217]:42640 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751696AbYEON15 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2008 09:27:57 -0400
From: Oliver Neukum <oliver@neukum.org>
Organization: NOvell
To: David Brownell <david-b@pacbell.net>
Subject: Re: [PATCH 1/1] [usb/host]: use get/put_unaligned_* helpers to fix more potential unaligned issues.
Date: Thu, 15 May 2008 15:27:53 +0200
User-Agent: KMail/1.9.9
Cc: "Bryan Wu" <cooloney@kernel.org>, "Jie Zhang" <jie.zhang@analog.com>,
       harvey.harrison@gmail.com, greg@kroah.com, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org
References: <1210832364-20012-1-git-send-email-cooloney@kernel.org> <200805151419.16026.oliver@neukum.org> <200805150603.21199.david-b@pacbell.net>
In-Reply-To: <200805150603.21199.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805151527.54699.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Donnerstag 15 Mai 2008 15:03:20 schrieben Sie:
> On Thursday 15 May 2008, Oliver Neukum wrote:
> > This is not very nice. If we pass around unaligned pointers we should mark
> > those not catch errors later on.
> 
> ISTR that GCC doesn't have a way to annotate pointers that way.

But we can do the _user annotation, can't we?

	Regards
		Oliver
