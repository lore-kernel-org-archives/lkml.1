Return-Path: <linux-kernel-owner+w=401wt.eu-S1752455AbXCHQYl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752455AbXCHQYl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2007 11:24:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752460AbXCHQYk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Mar 2007 11:24:40 -0500
Received: from web36605.mail.mud.yahoo.com ([209.191.85.22]:22650 "HELO
	web36605.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752455AbXCHQYj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2007 11:24:39 -0500
X-YMail-OSG: EhkcDYEVM1lGvfykYp9riLgJevjSDeMjycrvbVc3aUdEhidRK_EERl2mifeaxTIjIw--
X-RocketYMMF: rancidfat
Date: Thu, 8 Mar 2007 08:24:38 -0800 (PST)
From: Casey Schaufler <casey@schaufler-ca.com>
Reply-To: casey@schaufler-ca.com
Subject: Re: Request change in behaviour of capability inheritance.
To: rgarcia@kotasoft.com, linux-kernel@vger.kernel.org
In-Reply-To: <15429.83.60.135.204.1173342736.squirrel@webmail2.digitalinet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <887.65866.qm@web36605.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--- rgarcia@kotasoft.com wrote:

> I think that the current behaviour of capability
> inheritance across exec()
> is not optimal.
> 
> The current behaviour consists in all effective and
> permitted capabilities
> are cleared across a exec(). This is because it
> seems to be intended that
> in the future the executable files have a set of
> "allowed" and "forced"
> capabilities.

File based capabilities are the same
effective, permitted, and inheritable
sets that the process has. Unless the
thinking has shifted over the last couple
weeks (it happens from time to time)
the inheritable set is what you're
missing.



Casey Schaufler
casey@schaufler-ca.com
