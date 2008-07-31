Return-Path: <linux-kernel-owner+w=401wt.eu-S1758137AbYGaTl2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758137AbYGaTl2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2008 15:41:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752771AbYGaTlR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jul 2008 15:41:17 -0400
Received: from outbound-mail-03.bluehost.com ([69.89.21.13]:55442 "HELO
	outbound-mail-03.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754552AbYGaTlQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2008 15:41:16 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id:X-Identified-User;
	b=OB/86GhTKmPmROk5sVAjSz1Y4omBqnDXIAk55f/3d65ZyO+uBKjgiO3piNGcUhzxCkhYPY3IWCz3hPiSoMNG/3z2J/1C0f1pYRrd92C6Cfx+D/0aPo31IEHyVZ6iiEf+;
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: "Benjamin Li" <benli@broadcom.com>
Subject: Re: [PATCH] PCI: Add limits to VPD read/write lengths for Broadcom 5706S, 5708S
Date: Thu, 31 Jul 2008 12:41:05 -0700
User-Agent: KMail/1.9.9
Cc: "Matthew Wilcox" <willy@linux.intel.com>, linux-pci@vger.kernel.org,
       linux-kernel@vger.kernel.org,
       "Linux Netdev List" <netdev@vger.kernel.org>,
       "Michael Chan" <mchan@broadcom.com>
References: <48920413.6080508@cosmosbay.com> <1217532284-7032-1-git-send-email-benli@broadcom.com> <1217532284-7032-2-git-send-email-benli@broadcom.com>
In-Reply-To: <1217532284-7032-2-git-send-email-benli@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807311241.06209.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, July 31, 2008 12:24 pm Benjamin Li wrote:
> Reading beyond the valid VPD limit will hang the Broadcom
> 5706S, 5708S.  During the check we need to add the additionial
> 5706S and 5708S PCI ID's when limiting the read/write VPD length.
>
> Signed-off-by: Benjamin Li <benli@broadcom.com>

I already applied Eric's 5708S patch, can you re-diff against my for-linus 
branch (in a few minutes after it mirrors out) and resend?  And please cc 
stable@vger.kernel.org, since they'll want these crash fixes too.

Thanks,
Jesse
