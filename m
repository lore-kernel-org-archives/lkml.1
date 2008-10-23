Return-Path: <linux-kernel-owner+w=401wt.eu-S1757721AbYJWV4T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757721AbYJWV4T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2008 17:56:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753742AbYJWV4G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Oct 2008 17:56:06 -0400
Received: from outbound-mail-12.bluehost.com ([69.89.18.112]:56694 "HELO
	outbound-mail-12.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753334AbYJWV4F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2008 17:56:05 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id:X-Identified-User;
	b=fqXEbgHCPvoDbX9zxMLa91xSeSVLbQU1smfMM9GPhAnEhqP8aKVHb1IdQvU05WwxUGCQwNYSVuqSZVLxozpB5Vp13zHT4LeJNJH6uEIHhRYHf9o3JItgSthG+aMJXlJ0;
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Subject: Re: [PATCH 1/2] pci: add misrouted interrupt error handling
Date: Thu, 23 Oct 2008 14:55:59 -0700
User-Agent: KMail/1.10.1 (Linux/2.6.26.5-45.fc9.x86_64; KDE/4.1.2; x86_64; ; )
Cc: "linux-scsi" <linux-scsi@vger.kernel.org>,
       "linux-kernel" <linux-kernel@vger.kernel.org>,
       linux-pci@vger.kernel.org
References: <1217786532.4179.24.camel@localhost.localdomain>
In-Reply-To: <1217786532.4179.24.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810231455.59437.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, August 3, 2008 11:02 am James Bottomley wrote:
> We're getting a lot of storage drivers blamed for interrupt misrouting
> issues.  This patch provides a standard way of reporting the problem
> ... and, if possible, correcting it.
>
> Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>

Ok, per our discussion at the PCI BoF I applied this, so now you can apply the 
fusion and other bits to help debug issues.

Thanks,
Jesse
