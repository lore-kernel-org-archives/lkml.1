Return-Path: <linux-kernel-owner+w=401wt.eu-S1759446AbZBXRjJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759446AbZBXRjJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Feb 2009 12:39:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760091AbZBXRiw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Feb 2009 12:38:52 -0500
Received: from outbound-mail-21.bluehost.com ([69.89.21.16]:48214 "HELO
	outbound-mail-21.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1758544AbZBXRiv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Feb 2009 12:38:51 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id:X-Identified-User;
	b=YUlWIWiBvjbvqHXn469B1qvXybjNxxzZRir+4Y9C27gmUbbWdk5yFMiv/ZbBQDBtyDRJ4OJcylWv4nk8TiYS1B7esdyTqF7tSLOjfArOBDPOYUJnXyWDjgYqD/cAPU6n;
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [PATCH] pciehp:  Handle interrupts that happen during initialization.
Date: Tue, 24 Feb 2009 09:38:43 -0800
User-Agent: KMail/1.11.0 (Linux/2.6.27-11-generic; KDE/4.2.0; x86_64; ; )
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
       Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
References: <m1pri623g9.fsf@fess.ebiederm.org>
In-Reply-To: <m1pri623g9.fsf@fess.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902240938.43560.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, January 28, 2009 7:31:18 pm Eric W. Biederman wrote:
> Move the enabling of interrupts after all of the data structures
> are setup so that we can safely run the interrupt handler as
> soon as it is registered.
>
> Signed-off-by: Eric W. Biederman <ebiederm@aristanetworks.com>

Applied to my for-linus branch, thanks.

-- 
Jesse Barnes, Intel Open Source Technology Center
