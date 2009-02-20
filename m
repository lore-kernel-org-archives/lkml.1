Return-Path: <linux-kernel-owner+w=401wt.eu-S1756074AbZBTC4s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756074AbZBTC4s (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Feb 2009 21:56:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751392AbZBTC4h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Feb 2009 21:56:37 -0500
Received: from web33507.mail.mud.yahoo.com ([68.142.206.156]:40491 "HELO
	web33507.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755430AbZBTC4g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Feb 2009 21:56:36 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:MIME-Version:Content-Type:Message-ID;
  b=KmMAxReQ/G6ujE0zYl99EpSk7vpZxDHmToA4QzC9TKlgApr7x0HMMjjmNuQF24a0JW/OmPSh6loNE0j8fTLgWP0AuO43uKsEpV8e1fiJP9LmKuH0+YzKFGH1cuIS6eZ6EMvTImX9q2CC9LRfEjQdxw38dPAGsISDawBXhz4xZ4c=;
X-YMail-OSG: wHNyU8AVM1noKIt24B2oFFlBRbx2xWK3FtMeUtPpGpC1VwqYvpjwK8c9HZI9tuP011VjXP4IU8OjwfrZBu9CASzDD5wvWc9u34g9x3XAcjs97IHHhLEWUn2JuopXXPE4cWAJaI6hZvAVb0cHHgOJDtm5fdEpvoGNlIJrNE6iKZj16h8W1eqelaaFh4sE
X-Mailer: YahooMailWebService/0.7.260.1
Date: Thu, 19 Feb 2009 18:49:54 -0800 (PST)
From: Nick Levinson <nick_levinson@yahoo.com>
Subject: suggest shutdown process end with on-screen message
To: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <274106.42702.qm@web33507.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

During shutdown, the screen goes uniformly dark. It's easy to confuse it with already being off. Turning power off prematurely can crash Linux for the next startup. I don't know if it's premature once the screen has reached uniform darkness, and I'm not willing to take the chance of trying it out, since recovering from a crash can be a looooooooooong process.

Compare to old Win95a (and maybe new Win), which displays a message telling me it's now safe to turn the computer's power off.

Suggestion: Create a configurable text message (no special font or artwork) that displays when the screen becomes uniformly dark and stays up till it's safe to power down. Let us decide what message we want, so we can edit it to be compatible with our hardware setup, such as "When this message goes away, you may turn the power off.", "Now in the final stages of shutting down. When this message disappears, implement Procedure 3J75.2 and call your CIO at home.", or simply "x" or whatever.

If no text can be displayed then, perhaps allow us to post a message just before text is impossible, and to have that message stay up for a configurable number of seconds, e.g., for 20 seconds, "When this message disappears in 20 seconds or less, wait another 15 seconds for the screen to go from dark to black before turning power off."

Reboot should be treated separately. Perhaps a configurable message could announce "Rebooting under way." or "Keep power on; awaiting reboot within 1 minute."

My current Linux laptop does not need its power turned off, but I unplug the power cable and might not have a functioning battery at that moment.

This is not needed for lean distros. It is needed as Linux moves toward more friendliness for wider user bases.

I'm running Linux Fedora Core 4 with kernel <2.6.11-1.1369_FC4>.

Thanks.

-- 
Nick


      
